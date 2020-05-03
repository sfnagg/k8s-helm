FROM alpine:3.11 as build

MAINTAINER Sergey Fomin <sf@nagg.ru>

ENV KUBECTL_VERSION v1.16.8
ENV HELM_VERSION 2.16.5

RUN set -ex && \
    apk add --no-cache curl bash ncurses && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sSL https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail -o /usr/local/bin/kubetail && \
    curl -sSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xz && mv /linux-amd64/helm /usr/local/bin/helm && \
    curl -sSL https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -o /usr/local/bin/stern && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/kubetail /usr/local/bin/helm /usr/local/bin/stern

CMD ["helm"]
