FROM telegraf:1.25

# Adding non-free repos in order to obtain snmp-mibs-downloader
RUN echo 'deb http://deb.debian.org/debian bullseye non-free' > /etc/apt/sources.list.d/bullseye-nonfree.list && \
    echo 'deb http://deb.debian.org/debian bullseye-updates non-free' > /etc/apt/sources.list.d/bullseye-nonfree-updates.list && \
    echo 'deb http://deb.debian.org/debian-security/ bullseye-security non-free' > /etc/apt/sources.list.d/bullseye-nonfree-security.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends snmp-mibs-downloader && \
    rm -rf /var/lib/apt/lists/*

COPY telegraf.conf /etc/telegraf/telegraf.conf
COPY PowerNet-MIB.txt /usr/share/snmp/mibs/PowerNet-MIB.txt

RUN telegraf --test
