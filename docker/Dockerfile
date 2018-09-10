# Details:
#

# Pull base image.
FROM ubuntu:16.04
# Maintainer
MAINTAINER Rob <rob@pd1rla.com>

RUN apt-get update \
	&& apt-get -y dist-upgrade -u \
	&& rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -y --no-install-recommends \
		net-tools inetutils-ping ca-certificates vim curl git make

####################### PERL STUFF ############################################################
RUN curl -o /usr/sbin/cpanm -LO https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm \
    && chmod +x /usr/sbin/cpanm \
    && cpanm App::cpanminus \
    && cpanm App::cpanoutdated

RUN cpanm App::cpanoutdated \
    && cpanm \
		Mojolicious

################# mojolicious ###############################
RUN cd /opt \
	&& git clone https://github.com/rlassche/mojolicious_websockets.git

###############################################################

EXPOSE 9090
WORKDIR /opt/mojolicious_websockets

CMD ["hypnotoad", "-f", "script/sdc" ]
