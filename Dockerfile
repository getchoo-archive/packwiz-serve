FROM golang:alpine3.17

WORKDIR /src

RUN apk update
RUN apk add git

RUN git clone https://github.com/packwiz/packwiz.git ./

# cache go modules
WORKDIR /build
RUN mv /src/go.mod ./ && mv /src/go.sum ./
RUN go mod download

# build packwiz
RUN mv /src/* ./
RUN go build -o /packwiz

WORKDIR /data
VOLUME /data

EXPOSE 8080

CMD [ "/packwiz", "serve" ]
