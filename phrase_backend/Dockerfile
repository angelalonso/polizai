#FROM liuchong/rustup
#
#
#ENV ROCKET_ADDRESS=0.0.0.0
#ENV ROCKET_PORT=8000
#
#ADD . /app
#
#WORKDIR /app
#
#RUN rustup default nightly
#
#RUN cargo build
#
#CMD ["cargo", "run"]

FROM alpine:3.13.2

RUN mkdir /app

ADD ./target/release/main /app/main
ADD ./data /app/data
ADD ./poetry.txt /app

#CMD ["/bin/ash", "-c", "ls -lha /app/"]
CMD ["/app/main"]
