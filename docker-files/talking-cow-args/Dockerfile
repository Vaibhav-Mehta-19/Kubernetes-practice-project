FROM alpine

ADD talkingcow-args.sh /

RUN apk update && apk add --no-cache fortune && chmod +x talkingcow-args.sh

ENTRYPOINT ["/bin/sh", "talkingcow-args.sh"]
CMD [ "10" ]