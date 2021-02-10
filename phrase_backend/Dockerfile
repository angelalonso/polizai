FROM liuchong/rustup


ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=8000

ADD . /app

WORKDIR /app

RUN rustup default nightly

RUN cargo build

CMD ["cargo", "run"]
