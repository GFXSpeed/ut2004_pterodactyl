FROM        --platform=$TARGETOS/$TARGETARCH debian:bullseye-slim

LABEL       author="GFXSpeed"

RUN         apt update \
            && apt -y upgrade
RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
            && apt install -y libstdc++6 lib32stdc++6 tar curl iproute2 openssl fontconfig dirmngr ca-certificates dnsutils tzdata zip tini \
            && apt install -y gcc-multilib lib32z1 lib32ncurses6 coreutils wget \
            && useradd -d /home/container -m container

RUN         wget https://s3.amazonaws.com/ut2004-files/libstdc%2B%2B5_3.3.6-20~lucid1_i386.deb \
            && apt install -y ./libstdc++5_3.3.6-20~lucid1_i386.deb

RUN         mkdir -p /run/systemd && echo 'docker' > /run/systemd/container
RUN         rm -rf /var/lib/apt/lists/*

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
