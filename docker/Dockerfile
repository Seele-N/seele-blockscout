FROM bitwalker/alpine-elixir-phoenix:1.11.4

RUN apk --no-cache --update add alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3 file

# Get Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ARG NETWORK_PATH=""
ARG SOCKET_ROOT=""

ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV MIX_ENV="prod"
ENV SOCKET_ROOT=${SOCKET_ROOT}
ENV NETWORK_PATH=${NETWORK_PATH}

# Cache elixir deps
ADD mix.exs mix.lock ./
ADD apps/block_scout_web/mix.exs ./apps/block_scout_web/
ADD apps/explorer/mix.exs ./apps/explorer/
ADD apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
ADD apps/indexer/mix.exs ./apps/indexer/
ADD docker/entrypoint.sh ./
ADD docker/prepend_npath.sh ./

RUN mix hex.config http_concurrency 1
RUN mix hex.config http_timeout 120

RUN mix do deps.get, local.rebar --force, deps.compile

ADD . .

RUN chmod +x ./prepend_npath.sh
RUN chmod +x ./entrypoint.sh

#RUN ./prepend_npath.sh

# Run forderground build and phoenix digest
RUN mix compile

# Add blockscout npm deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd -

RUN cd apps/explorer/ && \
    npm install && \
    apk update && apk del --force-broken-world alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3


RUN cd apps/block_scout_web/ && \
    mix phx.digest

ENTRYPOINT [ "./entrypoint.sh" ]