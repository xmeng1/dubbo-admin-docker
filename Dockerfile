FROM maven:3.5-jdk-8-alpine AS build
LABEL Author="chenchuxin <idesireccx@gmail.com>"
WORKDIR /src
RUN apk add --no-cache git \
    && git clone -b develop https://github.com/xmeng1/incubator-dubbo-ops.git \
    && cd incubator-dubbo-ops \
    && mvn package -Dmaven.test.skip=true

# timezone    
RUN apk add -U tzdata \
    && cp /usr/share/zoneinfo/Europe/London /etc/localtime

FROM tomcat:9-jre8-alpine
# timezone
COPY --from=build /etc/localtime /etc/localtime
WORKDIR /usr/local/tomcat/webapps
ARG version=2.0.0
ARG adminVersion=0.0.1-SNAPSHOT
RUN rm -rf ROOT
COPY --from=build /src/incubator-dubbo-ops/dubbo-admin/target/dubbo-admin-${adminVersion}.war .
RUN mv dubbo-admin-${version}.war ROOT.war
