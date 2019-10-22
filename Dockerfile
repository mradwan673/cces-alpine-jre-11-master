FROM alpine:3.9.2 as jlink-package
RUN mkdir /opt; cd /opt; \ 
    wget https://cdn.azul.com/zulu/bin/zulu11.2.3-jdk11.0.1-linux_musl_x64.tar.gz \
    && tar zxf zulu11.2.3-jdk11.0.1-linux_musl_x64.tar.gz \
    && ln -s zulu11.2.3-jdk11.0.1-linux_musl_x64 java \
    && rm -f zulu11.2.3-jdk11.0.1-linux_musl_x64.tar.gz 

ENV JAVA_HOME=/opt/java
ENV PATH="$PATH:$JAVA_HOME/bin"

RUN jlink \
     --module-path /opt/java/jmods \
     --compress=2 \
     --add-modules java.base,java.sql,java.logging,java.xml,java.naming,java.desktop,java.management,java.instrument,jdk.unsupported,java.security.jgss \
     --no-header-files \
     --no-man-pages \
     --strip-debug \
     --output /opt/jdk-11-mini-runtime 

FROM alpine:3.9.2

RUN apk add dumb-init

ENV JAVA_HOME=/opt/jdk-11-mini-runtime
ENV PATH="$PATH:$JAVA_HOME/bin"
COPY --from=jlink-package /opt/jdk-11-mini-runtime /opt/jdk-11-mini-runtime
