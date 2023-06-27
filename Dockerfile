FROM crystallang/crystal:latest

WORKDIR /app

COPY shard.yml shard.lock ./

RUN shards install

COPY . .

EXPOSE 3000

CMD ["crystal", "src/server.cr" ]
