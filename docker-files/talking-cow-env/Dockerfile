FROM alpine

ADD talkingcow-env.sh /

RUN apk update && apk add --no-cache fortune && chmod +x talkingcow-env.sh

ENTRYPOINT ["/bin/sh", "talkingcow-env.sh"]
CMD [ "10" ]