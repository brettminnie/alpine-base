FROM alpine:3.7

ENV HOME /root
ARG APK_PACKAGES="dos2unix git wget dnsmasq unzip zip python python3 py-pip python-dev py-setuptools build-base bash openntpd tzdata groff jq"
ARG RUBY_PACKAGES="ruby ruby-bundler libstdc++ tzdata ca-certificates ruby-dev"
MAINTAINER "Brett Minnie"

RUN apk add --update ${APK_PACKAGES} ${RUBY_PACKAGES}; \
    pip install --upgrade pip; \
    pip install --upgrade awscli; \
    adduser -D -u 1000 tools; \
    gem update --system; \
    gem install inspec; \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime; \
    echo "Europe/London" >  /etc/timezone; \
    apk del python-dev ruby-dev build-base py-setuptools tzdata; \
    rm -rf ~/.cache ~/.gems; \
    rm -rf /var/cache/apk/*; \
    apk update

COPY docker/etc/conf.d/ /etc/conf.d/
COPY docker/etc/periodic/hourly/ /etc/periodic/hourly/
COPY docker/tests /home/tools/tests

ENV HOME /home/tools
USER tools
RUN mkdir -p /home/tools/data

CMD ["/bin/bash"]
ENV PAGER "busybox more"
ENV USER "tools"
