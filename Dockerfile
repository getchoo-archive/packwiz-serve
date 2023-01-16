FROM docker.io/golang:alpine3.17 AS build

RUN apk add --no-cache git=2.38.2-r0

RUN git clone https://github.com/packwiz/packwiz.git /build

WORKDIR /build
RUN go mod download
RUN go build

FROM docker.io/alpine:3.17

RUN mkdir /app
COPY --from=build /build/packwiz /app/

WORKDIR /data
VOLUME /data

EXPOSE 8080

CMD [ "/app/packwiz", "serve" ]
