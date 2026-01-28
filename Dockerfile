# Build the game in a base container
FROM alpine:3.23.3 AS builder
LABEL "Maintainer"="Florian Piesche <florian@yellowkeycard.net>"

ARG IOQUAKE3_COMMIT="unknown"
ENV IOQUAKE3_COMMIT=${IOQUAKE3_COMMIT}

ADD ./ioq3 /ioq3
WORKDIR /ioq3/build
RUN apk --no-cache add curl g++ gcc cmake samurai
RUN rm /ioq3/.git
RUN cmake -GNinja \
        -DBUILD_CLIENT=OFF \
        -DBUILD_RENDERER_GL1=OFF \
        -DBUILD_RENDERER_GL2=OFF \
        -DPRODUCT_VERSION=${IOQUAKE3_COMMIT} \
        -DBUILD_GAME_QVMS=OFF \
        ..
RUN cmake --build .
RUN cmake --install .

# Copy the game files from the builder container to a new image to minimise size
FROM alpine:3.23.3 AS ioq3ded
LABEL "Maintainer"="Florian Piesche <florian@yellowkeycard.net>"

ARG IOQUAKE3_COMMIT="unknown"
ENV IOQUAKE3_COMMIT=${IOQUAKE3_COMMIT}

RUN adduser ioq3ded -D
COPY --chown=ioq3ded --from=builder /opt/quake3/ioq3ded /opt/quake3/ioq3ded
ADD --chown=ioq3ded files/ /opt/quake3/

USER ioq3ded
EXPOSE 27960/udp
VOLUME [ "/opt/quake3/baseq3"]
CMD ["/opt/quake3/entrypoint.sh"]
