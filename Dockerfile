FROM --platform=${TARGETPLATFORM:-linux/amd64} curlimages/curl as downloader

ARG VERSION

RUN curl -L https://github.com/Anuken/Mindustry/releases/download/v${VERSION}/server-release.jar -o /tmp/server.jar

FROM --platform=${TARGETPLATFORM:-linux/amd64} openjdk:8-jdk-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="krosf" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/krosf/mindustry-docker" \
  org.opencontainers.image.source="https://github.com/Anuken/Mindustry" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="krosf" \
  org.opencontainers.image.title="mindustry" \
  org.opencontainers.image.description="Mindustry Docker Image" \
  org.opencontainers.image.licenses="MIT"

RUN addgroup -S mindustry \
  && adduser -S -g mindustry mindustry

USER mindustry

COPY --from=downloader /tmp/server.jar /home/mindustry/server.jar
WORKDIR /home/mindustry

EXPOSE 6567/TCP
EXPOSE 6567/UDP

VOLUME [ "/home/mindustry/config" ]
CMD [ "java", "-jar", "server.jar" ]