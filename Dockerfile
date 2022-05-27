FROM docker.jfrog.skillz.com/golang:1.18 AS build-env

RUN apt-get update && apt-get install -y openjdk-11-jre maven

# Required private access. To build locally, see https://github.com/skillz/golang-microtest-1/wiki/Using-private-repository
ARG GITHUB_TOKEN
RUN go env -w GOPRIVATE='github.com/skillz/*' && \
	git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/skillz".insteadOf "https://github.com/skillz"

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download -x

ARG ARTIFACTORY_USERNAME
ARG ARTIFACTORY_PASSWORD

ENV \
    ARTIFACTORY_USERNAME=${ARTIFACTORY_USERNAME} \
    ARTIFACTORY_PASSWORD=${ARTIFACTORY_PASSWORD} \
	CGO_ENABLED=0 \
	GOOS=linux \
	GOARCH=amd64
COPY . .
RUN make server

FROM docker.jfrog.skillz.com/alpine:3.14 AS runtime
COPY --from=build-env /app/server /server

COPY config.yaml /config.yaml
ENTRYPOINT ["/server"]
