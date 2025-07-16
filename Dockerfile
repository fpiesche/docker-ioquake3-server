# Build the game in a base container
FROM alpine:3.22.1 AS builder
LABEL "Maintainer" "Florian Piesche <florian@yellowkeycard.net>"

ENV SERVERBIN ioq3ded
ENV BUILD_CLIENT 0

ADD ./ioq3 /ioq3
RUN \
  apk --no-cache add curl g++ gcc make && \
  cd /ioq3 && \
  make && \
  make copyfiles

# Copy the game files from the builder container to a new image to minimise size
FROM alpine:3.22.1 AS ioq3srv
ARG IOQUAKE3_COMMIT="unknown"
LABEL "Maintainer" "Florian Piesche <florian@yellowkeycard.net>"

ENV IOQUAKE3_COMMIT ${IOQUAKE3_COMMIT}

RUN adduser ioq3srv -D
COPY --chown=ioq3srv --from=builder /usr/local/games/quake3 /usr/local/games/quake3
ADD --chown=ioq3srv files/ /usr/local/games/quake3/

USER ioq3srv
EXPOSE 27960/udp
VOLUME [ "/usr/local/games/quake3/baseq3"]
CMD /bin/sh /usr/local/games/quake3/entrypoint.sh
