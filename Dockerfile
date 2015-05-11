FROM ubuntu:14.04
MAINTAINER Alexey Diyan <alexey.diyan@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y pulseaudio:i386 firefox:i386 wget
# TODO remove hardcoded uid/gid, do this after jre installation
ENV DISPLAY='unix:0' PULSE_SERVER=unix:/run/pulse GROUP_ID=1000 USER_ID=1000
# Create user with the same uid/gid as host user to use pulseaudio socket
RUN groupadd -f -g $GROUP_ID webex
RUN adduser --uid $USER_ID --gid $GROUP_ID --disabled-login --gecos 'WebEx' webex
#RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#    -O /tmp/jre7.tgz  \
#    http://download.oracle.com/otn-pub/java/jdk/7u72-b14/jre-7u72-linux-i586.tar.gz
#RUN mkdir -p /opt/jre7 && tar -xzvf /tmp/jre7.tgz --strip=1 -C /opt/jre7
#RUN mkdir -p /usr/lib/mozilla/plugins/
#RUN update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/opt/jre7/lib/i386/libnpjp2.so" 1
#RUN update-alternatives --set "mozilla-javaplugin.so" "/opt/jre7/lib/i386/libnpjp2.so"
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    -O /tmp/jre8.tgz  \
    http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-i586.tar.gz
RUN mkdir -p /opt/jre8 && tar -xzvf /tmp/jre8.tgz --strip=1 -C /opt/jre8
RUN mkdir -p /usr/lib/mozilla/plugins/
RUN update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/opt/jre8/jre/lib/i386/libnpjp2.so" 1
RUN update-alternatives --set "mozilla-javaplugin.so" "/opt/jre8/jre/lib/i386/libnpjp2.so"

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libcanberra-pulse:i386

# Disable "Click to run" Java applet
# Disable Java out of date warning
# Setup nice Java theme, fix Java font rendering
USER webex
#ENV MOZ_PLUGIN_PATH=/opt/jre7/lib/i386/
#CMD /usr/bin/firefox --new-instance https://www.youtube.com/watch?v=Djj7jW6ny2M
#CMD /usr/bin/firefox --new-instance about:plugins
CMD bash
