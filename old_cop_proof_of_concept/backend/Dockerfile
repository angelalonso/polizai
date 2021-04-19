FROM rustdocker/rust:nightly as cargo-build 

RUN apt-get update 
RUN apt-get install musl-tools -y 
RUN /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl 
RUN USER=root /root/.cargo/bin/cargo new --bin polizai_be 

WORKDIR /polizai_be 

COPY ./Cargo.toml ./Cargo.toml 
COPY ./Cargo.lock ./Cargo.lock 

RUN RUSTFLAGS=-Clinker=musl-gcc /root/.cargo/bin/cargo build --release --target=x86_64-unknown-linux-musl 
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/polizai_be* 
RUN rm src/*.rs 

COPY ./src ./src 

RUN RUSTFLAGS=-Clinker=musl-gcc /root/.cargo/bin/cargo build --release --target=x86_64-unknown-linux-musl

FROM alpine:latest 

COPY --from=cargo-build /polizai_be/target/x86_64-unknown-linux-musl/release/main . 
COPY ./data . 

CMD ["./main"]
#CMD ["/bin/ash", "-c", "ls -lha /"]

