# Imagem base com o Crystal instalado
FROM crystallang/crystal:1.2.0-alpine AS build

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo shard.yml e shard.lock para o diretório de trabalho
COPY shard.yml shard.lock ./

# Instalar as dependências
RUN shards install --production

# Copiar o código-fonte para o diretório de trabalho
COPY src ./src
RUN crystal build --release src/server.cr -o app

FROM alpine:latest

RUN apk add --no-cache libstdc++ libgcc postgresql-client

COPY --from=build /app/app /app/app

WORKDIR /app

EXPOSE 3000

CMD ["./app"]