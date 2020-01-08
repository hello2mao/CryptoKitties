FROM mhart/alpine-node:latest

RUN apk update && apk add bash vim tzdata geth \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD . /CryptoKitties
WORKDIR /CryptoKitties

RUN npm install

EXPOSE  3000 8545
CMD ["sh", "run.sh"]