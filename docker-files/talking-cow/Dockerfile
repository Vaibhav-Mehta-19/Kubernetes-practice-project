FROM alpine

ADD talkingcow.sh /

RUN apk update && apk add --no-cache fortune && chmod +x talkingcow.sh

ENTRYPOINT ["fortune"]