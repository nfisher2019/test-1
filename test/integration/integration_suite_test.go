package integration_test

import (
	"testing"

	. "github.com/onsi/ginkgo/v2"
    _ "github.com/onsi/ginkgo/v2/ginkgo/generators"
    _ "github.com/onsi/ginkgo/v2/ginkgo/labels"
	. "github.com/onsi/gomega"
)

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Integration Suite")
}
