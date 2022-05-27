package internal

import (
	"flag"
	log "github.com/sirupsen/logrus"
	"github.com/skillz/go-http/config"
	"github.com/skillz/go-utils/aws_utils"
	"os"
	"time"
)

type RuntimeConfig struct {
	Profile    string
	ConfigPath string
}

type envs struct {
	Dev               Config `yaml:"dev"`
	Qa                Config `yaml:"qa"`
	QaSandbox         Config `yaml:"qa-sandbox"`
	Staging           Config `yaml:"staging"`
	StagingSandbox    Config `yaml:"staging-sandbox"`
	Production        Config `yaml:"production"`
	ProductionSandbox Config `yaml:"production-sandbox"`
}

type Config struct {
	LogLevel               string                    `yaml:"log_level"`
	Addr                   string                    `yaml:"addr"`
	HideStartupBanner      bool                      `yaml:"hide_startup_banner"`
	EnableDatadogTracer    bool                      `yaml:"enable_datadog_tracer"`
	TerminationGracePeriod time.Duration             `yaml:"termination_grace_period"`
	AwsClientConfig        aws_utils.AwsClientConfig `yaml:"aws_client_config"`
}

func GetRuntimeConfigFromFlags() RuntimeConfig {
	profile := flag.String("profile", os.Getenv("PROFILE"), "Config profile to use")
	configPath := flag.String("config", "./config.yaml", "Path to config file")
	flag.Parse()

	return RuntimeConfig{
		Profile:    *profile,
		ConfigPath: *configPath,
	}
}

func ParseConfig(runtimeConfig RuntimeConfig) Config {
	// Parse config
	envs := envs{}
	if err := config.YamlEnv(&envs, runtimeConfig.ConfigPath, config.Opts{}); err != nil {
		log.Error(err)
		os.Exit(1)
	}
	// Get active profile's config
	switch runtimeConfig.Profile {
	case "prod":
		return envs.Production
	case "production":
		return envs.Production
	case "production-sandbox":
		return envs.ProductionSandbox
	case "staging":
		return envs.Staging
	case "staging-sandbox":
		return envs.StagingSandbox
	case "qa":
		return envs.Qa
	case "qa-sandbox":
		return envs.QaSandbox
	default:
		return envs.Dev
	}
}
