FROM debian:jessie AS builder

# You'll need to change `libmysqlclient-dev` to `libpq-dev` if you're using Postgres
RUN apt-get update && apt-get install -y curl musl-tools musl-dev libpq-dev

# Install rust
RUN curl https://sh.rustup.rs/ -sSf | \
  sh -s -- -y --default-toolchain nightly

ENV PATH="/root/.cargo/bin:${PATH}"

ADD . ./

RUN cargo build --release

FROM debian:jessie

COPY --from=builder \
  /target/release/polizai_back \
  /usr/local/bin/

RUN apt-get update && apt-get install -y libpq-dev

EXPOSE 8000

WORKDIR /root
CMD /usr/local/bin/polizai_back
