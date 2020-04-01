FROM ubuntu:latest
RUN apt-get update ; apt-get -y install fortune ; apt-get -y install cowsay;
ADD talking-cow.sh /bin/talking-cow.sh
ENTRYPOINT /bin/talking-cow.sh