FROM debian:latest
MAINTAINER MoeArt Developmemnt Team <dev@art.moe>

#////////////////////////////////////////////////////////////////////
#//                                  ______
#//     ____ _  _____   ____ _  ____/ /   _____  ____ _ _      ____
#//   / __ `/ / ___/  / __ `/ / __  /   / ___/ / __ `/| | /| / /
#//  / /_/ / / /__   / /_/ / / /_/ /   / /    / /_/ / | |/ |/ /
#//  \__,_/  \___/   \__, /  \__,_/   /_/     \__,_/  |__/|__/
#//                 /____/
#//
#////////////////////////////////////////////////////////////////////

#########################
##                     ##
##     S Y S T E M     ##
##                     ##
#########################
# initize debian base system
ENV MAID_CHAN_USER www-data
ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL C
ENV HHVM_DISABLE_NUMA true

# initize debian software source
# and base packages
RUN sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list
RUN sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y cron wget gnupg lsb-release
RUN mkdir -p /usr/src

# configure timezone and locale
# set to Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/Asia/Chongqing /etc/localtime && echo Asia/Chongqing > /etc/timezone



#########################
##                     ##
##    T E N G I N E    ##
##                     ##
#########################
WORKDIR /usr/src
ADD https://github.com/alibaba/tengine/archive/master.tar.gz tengine.tar.gz

# install compile toolchian
# and libraries for development
RUN apt-get install -y \
    build-essential \
    libpcre3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libgd2-dev \
    libgeoip-dev \
    libperl-dev \
    zlib1g-dev
        
# unpackage tengine source code
# and modify version information
RUN tar -zxvf tengine.tar.gz && \
    cd tengine-master && \
    sed -i " \
        /#define TENGINE.*/s/\"Tengine/\"MoeArt Maid-chan/; \
        /#define tengine_version.*/s/[0-9]\{7\}/`date +%y%m0%d`/; \
        /#define TENGINE_VERSION.*/s/\".*\"/\"`date +%y.%m.%d`\"/; \
        /#define NGINX_VER.*/s/\"nginx/\"MoeArt Maid-chan/; \
        /#define NGINX_VAR.*/s/\"NGINX/\"MoeArt Maid-chan/; \
        " src/core/nginx.h && \
    sed -i " \
        s/ Sorry for the inconvenience./ And, Maid-chan donot know what you need./; \
        s/Please report this message and include the following information to us./Please report this message and include the following information to Maid-chan./; \
        s/Thank you very much/Inconvenience to you my sincere apologies/; \
        " src/http/ngx_http_special_response.c

# configure tengine source code
WORKDIR /usr/src/tengine-master
RUN ./configure \
        --enable-mods-static=all \
        --user=$MAID_CHAN_USER \
        --group=$MAID_CHAN_USER \
        --prefix=/usr/share/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/run/nginx.pid \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --with-md5=/usr/include/openssl \
        --with-sha1-asm \
        --with-md5-asm \
        --with-http_auth_request_module \
        --with-http_image_filter_module \
        --with-http_addition_module \
        --with-http_realip_module \
        --with-http_sysguard_module \
        --with-http_v2_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-http_concat_module \
        --with-http_upstream_ip_hash_module=shared \
        --with-http_upstream_least_conn_module=shared \
        --with-http_upstream_session_sticky_module=shared \
        --with-http_map_module=shared \
        --with-http_user_agent_module=shared \
        --with-http_mp4_module \
        --with-http_split_clients_module=shared \
        --with-http_access_module=shared \
        --with-http_user_agent_module=shared \
        --with-http_degradation_module \
        --with-http_upstream_check_module \
        --with-http_upstream_consistent_hash_module \
        --with-ipv6 \
        --with-file-aio \
        --with-pcre \
        --with-pcre-jit \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/sbin/nginx

# make tengine source code to binary
RUN make

# install tengine to alpine linux
RUN make install && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/ngx_pagespeed_cache && \
    mkdir -p /var/log/pagespeed && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /var/lib/nginx/body && \
    mkdir -p /var/www && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/cache/nginx && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/ngx_pagespeed_cache && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/log/nginx && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/log/pagespeed && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /etc/nginx/sites-available && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /etc/nginx/sites-enabled && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/lib/nginx/body && \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/www

# add configuration files
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/mime.types /etc/nginx/mime.types
ADD conf/default /etc/nginx/sites-enabled/default
ADD html/ /etc/nginx/html/



#########################
##                     ##
##       H H V M       ##
##                     ##
#########################
RUN wget -O /tmp/hhvm.gpg.key http://s3-us-west-2.amazonaws.com/hhvm-downloads/conf/hhvm.gpg.key && \
    apt-key add /tmp/hhvm.gpg.key && \
    echo "deb http://s3-us-west-2.amazonaws.com/hhvm-downloads/debian/ $(lsb_release -c|awk '{print $2}') main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y hhvm && \
    sed -i 's|start-stop-daemon|start-stop-daemon --chuid $RUN_AS_USER:$RUN_AS_GROUP|g' /etc/init.d/hhvm

# add configuration files
RUN rm /etc/hhvm -rf
ADD conf/hhvm/ /etc/hhvm/

# create workdir
RUN mkdir -p /var/lib/hhvm & \
    mkdir -p /var/run/hhvm & \
    mkdir -p /var/log/hhvm & \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/lib/hhvm & \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/run/hhvm & \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /var/log/hhvm & \
    chown -R $MAID_CHAN_USER:$MAID_CHAN_USER /etc/hhvm/disable_functions.php



#########################
##                     ##
##      C L E A N      ##
##                     ##
#########################
RUN apt-get remove -y \
    build-essential \
    libpcre3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libgd2-dev \
    libgeoip-dev \
    libperl-dev \
    zlib1g-dev \
    wget \
    gnupg \
    lsb-release
RUN apt-get autoremove -y
RUN apt-get install -y \
    libpcre3 \
    libssl1.1 \
    libxml2 \
    libxslt1.1 \
    libgd3 \
    libgeoip1 \
    libperl5.24 \
    zlib1g
WORKDIR /usr/src
RUN rm -rf /usr/src && \
    apt-get clean all && \
    rm -rf /tmp/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log



#########################
##                     ##
##       M A I D       ##
##                     ##
#########################
ADD script/maid /maid
RUN chmod +x /maid

VOLUME ["/var/log/nginx"]

WORKDIR /etc/nginx
EXPOSE 80 443
CMD ["/maid"]
