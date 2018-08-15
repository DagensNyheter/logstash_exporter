FROM golang:1.9 as golang

ADD . $GOPATH/src/github.com/perimeterx/logstash_exporter/
RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 && \
        chmod +x /usr/local/bin/dep && \
        go get -u github.com/perimeterx/logstash_exporter && \
        cd $GOPATH/src/github.com/perimeterx/logstash_exporter && \
        dep ensure && \
        make

FROM busybox:1.27.2-glibc
COPY --from=golang /go/src/github.com/perimeterx/logstash_exporter/logstash_exporter.go /
EXPOSE 9198
ENTRYPOINT ["/logstash_exporter"]
