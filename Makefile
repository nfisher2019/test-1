GEN_DIR=gen
MOCKGEN=mockgen
OUT_DIR=out

all: server

setup:
	go install github.com/onsi/ginkgo/v2/ginkgo
	go install github.com/golang/mock/mockgen@v1.6.0
	go install golang.org/x/tools/cmd/goimports@latest

server: generate
	go build ./gen/server

clean:
	rm -rf ./gen
	rm -rf ./server
	rm -rf .m

run: generate
	go run ./gen/server --profile dev

generate: setup mocks
	# Generate server
	GO_POST_PROCESS_FILE="goimports -w" .generator/skillz-openapi-generator-cli generate -i ./openapi.yaml -g go-skillz-server -ppackageName=server-go-microtest-1,defaultBranch=main,jsonOmitempty=false -o `pwd` --enable-post-process-file

mocks: generate
	#${MOCKGEN} --build_flags=--mod=mod -destination=$(GEN_DIR)/mocks/sqs_processor_mock.gen.go -package=mock_processor idempotency-examples/internal/service SqsProcessor

lint: mocks
	go test ./...
	golangci-lint run ./...

test: unit_test integration_tests

unit_test: mocks
	ginkgo -v -r -p --junit-report=TEST-Unit.xml -output-dir=out/test-results --cover --skip-package=test/integration

integration_tests: generate
	ginkgo -r --junit-report=TEST-Integration.xml -output-dir=out/test-results test/integration

# Local dev only: show test coverage in browser
showcoverage: unit_test
	go tool cover -html=out/test-results/coverprofile.out -o out/test-results/coverage.html
	open ${PWD}/out/test-results/coverage.html

.PHONY: setup clean run generate mocks lint test unit_test integration_tests showcoverage
