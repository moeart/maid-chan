# maid-chan
MoeArt Maid Chan is a web engine for website or web application. It's based on tengine, nginx and PHP7. It's a high performance web application server. - www.acgdraw.com

### For More Information
* for **debian8/php5.6** at
    ```
    https://github.com/moeart/maid-chan/tree/php5
        or
    docker pull moeart/maid-chan:php5
    ```
* for **debian9/hhvm3.26** at
    ```
    https://github.com/moeart/maid-chan/tree/hhvm3
        or
    docker pull moeart/maid-chan:hhvm3
    ```

more please visit https://hub.docker.com/r/moeart/maid-chan

### Includes
```
* latest version debian base system
* latest version tengine
* latest PHP7.0 engine
```

### Changelog
Date: 2018-6-13 (Y-M-D)
```
* update debian from 8 to 9
* update tengine source code
* upgrade PHP 5.6 to 7.0
* replace software source from debian to USTC
```

### Deploy Demo
```
docker run \
    --hostname example.acgdraw.com \
    --sysctl net.core.somaxconn=1024 \
    -v mywebapp.key:/etc/ssl/mywebapp.key \
    -v mywebapp.crt:/etc/ssl/mywebapp.crt \
    -v www.conf:/etc/nginx/sites-enabled/www \
    -v mywebapp.cron:/var/spool/cron/crontabs/root \
    -v mywebapp/:/var/www \
    --name example_webapp \
    --restart always \
    -d moeart/maid-chan
```

### Thanks
* debian
* docker
* nginx
* tengine
* php.org
* github
* stackoverflow
* ustc.edu.cn
* ttlsa.com
* 51cto.com
* linuxeye.cn
* chinaunix.net

### WARNING
PLEASE DO NOT RESELL THIS SOFTWARE, YOU CAN USE IT IN YOUR COMPANY.

---
(c)2018 MoeArt Development Team
