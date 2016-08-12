FROM docker:dind

MAINTAINER cmoon@kenzan.com

COPY compose /compose

COPY entrypoint.sh /entrypoint.sh

RUN apk update

RUN apk add git curl vim bash wget

RUN apk add 'py-pip==8.1.2-r0'

RUN pip install 'docker-compose==1.8.0'

RUN apk --no-cache add ca-certificates
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk
RUN apk add glibc-2.23-r3.apk

# Install kubectl
RUN apk add --update -t deps curl ca-certificates \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/v1.0.1/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*


RUN kubectl config set-cluster kubeception --server=http://localhost:8080

RUN kubectl config set-context kubeception --cluster=kubeception

RUN kubectl config use-context kubeception

EXPOSE 8080

CMD ["/entrypoint.sh"]