package internal

import (
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
	"github.com/skillz/go-utils/healthcheck"
	"server-go-microtest-1/gen/server/api"
)

func Configure(e *echo.Echo, conf Config) {
	log.Info("configuring service")
	//log.Info(fmt.Sprintf("Initializing DynamoDB client: config=%+v", conf.AwsClientConfig))
	//awsConfig, err := aws_utils.NewAwsConfig(context.Background(), conf.AwsClientConfig)
	//if err != nil {
	//	log.Fatalf("failed to initialize aws config")
	//}
	//dynamoClient := dynamodb.NewFromConfig(awsConfig)
	//if err != nil {
	//	log.Fatalf("unable to create dynamo client: %s", err.Error())
	//}
	//
	//sqsClient := sqs.NewFromConfig(awsConfig)

	c := api.NewDefaultController()


	// Use generated function to register handlers
	//openapi.RegisterHandlers(e, controller)
	//e.Validator = NewUserCurrencyValidator()
	api.RegisterController(e, c)

    healthcheck.RegisterHandlers(e)
}
