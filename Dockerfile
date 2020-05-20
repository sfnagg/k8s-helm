FROM alpine:3.11 as build

MAINTAINER Sergey Fomin <sf@nagg.ru>

ENV KUBECTL_VERSION 1.18.2
ENV HELM_VERSION 3.2.1

RUN set -ex && \
    apk add --no-cache curl bash && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xz && mv /linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/helm

CMD ["helm"]
