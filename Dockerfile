FROM alpine
LABEL maintainer="mg@michaelgoldstein.co"
# webproc release settings
ENV WEBPROC_VERSION v0.3.3
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/$WEBPROC_VERSION/webproc_0.3.3_linux_armv6.gz
# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add dnsmasq \
	&& apk add --no-cache --virtual .build-deps curl \
	&& curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc \
	&& apk del .build-deps
#configure dnsmasq - will mount config file
#RUN mkdir -p /etc/default/
#RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
#COPY dnsmasq.conf /etc/dnsmasq.conf
RUN addgroup -S appgroup && adduser -D -H -S appuser -G appgroup
#run!
ENTRYPOINT ["webproc","--","dnsmasq","--no-daemon","--user=appuser","--group=appgroup"]
