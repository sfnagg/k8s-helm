FROM alpine:3.11 as build

MAINTAINER Sergey Fomin <sf@nagg.ru>

ENV KUBECTL_VERSION v1.16.8
ENV HELM_VERSION 2.16.5

RUN set -ex && \
    apk add --no-cache curl && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sSL https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail -o /usr/local/bin/kubetail && \
    curl -sSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xz && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/kubetail /linux-amd64/helm

FROM alpine:3.11

COPY --from=build /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=build linux-amd64/helm /usr/local/bin/helm 
COPY --from=build /usr/local/bin/kubetail /usr/local/bin/kubetail

CMD ["helm"]
