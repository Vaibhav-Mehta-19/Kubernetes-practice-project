FROM ubuntu:latest
RUN apt-get update ; apt-get -y install fortune ; apt-get -y install cowsay;
WORKDIR /app/src
ADD talking-cow.sh .
ENTRYPOINT talking-cow.sh