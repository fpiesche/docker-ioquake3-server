# Build the game in a base container
FROM alpine:3.13 AS builder
LABEL "Maintainer" "Florian Piesche <florian@yellowkeycard.net>"

ENV IOQUAKE3_COMMIT ${IOQUAKE3_COMMIT}
ENV SERVERBIN ioq3ded
ENV BUILD_CLIENT 0

ADD ./ioq3 /ioq3
RUN \
  echo "----- Installing prerequisites..." && \
  apk --no-cache add curl g++ gcc make

RUN \
  echo "----- Building ioquake3 ${IOQUAKE3_COMMIT}..." && \
  cd /ioq3 && \
  make

RUN \
  echo "----- Copying ioquake3 files..." && \
  make copyfiles

# Copy the game files from the builder container to a new image to minimise size
FROM alpine:3.13 AS ioq3srv
LABEL "Maintainer" "Florian Piesche <florian@yellowkeycard.net>"

ENV IOQUAKE3_COMMIT ${IOQUAKE3_COMMIT}

RUN adduser ioq3srv -D
COPY --chown=ioq3srv --from=builder /usr/local/games/quake3 /usr/local/games/quake3
ADD --chown=ioq3srv files/ /usr/local/games/quake3/

USER ioq3srv
EXPOSE 27960/udp
VOLUME [ "/usr/local/games/quake3/baseq3"]
CMD /bin/sh /usr/local/games/quake3/entrypoint.sh
