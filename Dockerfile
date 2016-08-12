FROM docker:dind

MAINTAINER cmoon@kenzan.com

COPY compose /compose

COPY entrypoint.sh /entrypoint.sh

RUN apk update

RUN apk add git curl vim bash wget

RUN apk add 'py-pip==8.1.2-r0'

RUN pip install 'docker-compose==1.8.0'

#RUN wget http://storage.googleapis.com/kubernetes-release/release/v1.2.0/bin/linux/amd64/kubectl

#RUN chmod +x kubectl

#RUN mv kubectl /kubectl

#RUN /kubectl config set-cluster kubeception --server=http://localhost:8080

#RUN /kubectl config set-context kubeception --cluster=kubeception

#RUN /kubectl config use-context kubeception

EXPOSE 8080

CMD ["/entrypoint.sh"]