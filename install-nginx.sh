#!/bin/sh

sudo apt-get install build-essential libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g zlib1g-dev lsb-base
cd /tmp/
mkdir custom_nginx
cd custom_nginx
mkdir build
wget http://nginx.org/download/nginx-1.8.0.tar.gz
wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz
wget http://www.openssl.org/source/openssl-1.0.2d.tar.gz
tar -xvf nginx-1.8.0.tar.gz
tar -xvf ngx_cache_purge-2.3.tar.gz
tar -xvf openssl-1.0.2d.tar.gz

cd nginx-1.8.0

./configure \
    --with-debug \
    --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
    --user=www-data --group=www-data --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module \
    --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module \
    --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module \
    --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module \
    --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_spdy_module \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,--as-needed' --with-ipv6 \
    --add-module=/tmp/custom_nginx/openssl-1.0.2d \
    --add-module=/tmp/custom_nginx/ngx_cache_purge-2.3 \

/usr/bin/make
/usr/bin/make install

sudo ln -s /tmp/custom_nginx/build/sbin/nginx /usr/sbin/nginx
