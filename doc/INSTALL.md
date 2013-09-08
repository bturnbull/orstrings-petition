Ubuntu 10.04 on Linode Install
==============================

This document details an Linode VPS Ubuntu 10.04 install that uses the following components:

  * Nginx -- Reverse proxy and static file webserver
  * Puma -- Rack application server
  * RBEnv -- Per application Ruby environment
  * PostgreSQL -- Application database
  * Capistrano -- Automated deployment

This pattern uses a convention of one user per application with a reverse proxy that routes requests to the appropriate applicaiton UNIX socket.  For this app, orstrings, a system user of the same name is created:

    adduser --system \
            --home=/opt/orstrings \
            --shell=/bin/bash \
            --disabled-login \
            --disabled-password \
            --group \
            orstrings

Nginx
-----

Install apt-get packages necessary to build Nginx

    sudo apt-get install libpcre3-dev \
                         build-essential \
                         libssl-dev

Retrive and unpack the Nginx source and desired 3rd party modules.  This configuration is meant to mimic the Ubuntu 10.04 package using an up-to-date Nginx.

    cd /build
    wget http://nginx.org/download/nginx-1.4.1.tar.gz
    wget -O nginx-upstream-fair.tar.gz \
            http://github.com/gnosek/nginx-upstream-fair/tarball/master
    tar -xvzf nginx-1.4.1.tar.gz
    mkdir nginx-1.4.1/modules
    tar -xvzf nginx-upstream-fair.tar.gz
    mv gnosek-nginx-upstream-fair-* nginx-1.4.1/modules/nginx-upstream-fair

Configure, build, and install Nginx with the following standard and thirdparty modules:

    cd /build/nginx-1.4.1
    ./configure --conf-path=/etc/nginx/nginx.conf \
                --error-log-path=/var/log/nginx/error.log \
                --pid-path=/var/run/nginx.pid \
                --lock-path=/var/lock/nginx.lock \
                --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/var/lib/nginx/body \
                --http-proxy-temp-path=/var/lib/nginx/proxy \
                --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
                --with-debug \
                --with-http_stub_status_module \
                --with-http_flv_module \
                --with-http_ssl_module \
                --with-http_dav_module \
                --with-http_gzip_static_module \
                --with-http_realip_module \
                --with-mail \
                --with-mail_ssl_module \
                --with-ipv6 \
                --add-module=/tmp/nginx-1.4.1/modules/nginx-upstream-fair \
                2>&1 | tee configure.out
    make 2>&1 | tee make.out
    make install 2>&1 | tee install.out

Create a system account and group to run Nginx worker processes under.

    adduser --system \
            --no-create-home \
            --disabled-login \
            --disabled-password \
            --group \
            nginx

Use the sites-available and sites-enabled method for nginx configuration management.  Start with an `/etc/nginx/nginx.conf` similar to:

    user nginx;
    worker_processes  1;
    
    error_log  /var/log/nginx/error.log;
    pid        /var/run/nginx.pid;
    
    events {
        worker_connections  1024;
        # multi_accept on;
    }
    
    http {
        include    /etc/nginx/mime.types;
    
        access_log /var/log/nginx/access.log;
    
        sendfile        on;
        #tcp_nopush     on;
    
        #keepalive_timeout  0;
        keepalive_timeout  65;
        tcp_nodelay        on;
    
        gzip  on;
        gzip_disable "MSIE [1-6]\.(?!.*SV1)";
    
        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
    }

Install an init.d script for nginx to `/etc/init.d/nginx` -- TODO switch to upstart.

    #! /bin/sh
    
    ### BEGIN INIT INFO
    # Provides:          nginx
    # Required-Start:    $local_fs $remote_fs $network $syslog
    # Required-Stop:     $local_fs $remote_fs $network $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: starts the nginx web server
    # Description:       starts nginx using start-stop-daemon
    ### END INIT INFO
    
    PATH=/usr/local/nginx/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    DAEMON=/usr/local/nginx/sbin/nginx
    NAME=nginx
    DESC=nginx
    
    test -x $DAEMON || exit 0
    
    # Include nginx defaults if available
    if [ -f /etc/default/nginx ] ; then
        . /etc/default/nginx
    fi
    
    set -e
    
    . /lib/lsb/init-functions
    
    test_nginx_config() {
      if nginx -t $DAEMON_OPTS
      then
        return 0
      else
        return $?
      fi
    }
    
    case "$1" in
      start)
        echo -n "Starting $DESC: "
            test_nginx_config
        start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
            --exec $DAEMON -- $DAEMON_OPTS || true
        echo "$NAME."
        ;;
      stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid \
            --exec $DAEMON || true
        echo "$NAME."
        ;;
      restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile \
            /var/run/$NAME.pid --exec $DAEMON || true
        sleep 1
            test_nginx_config
        start-stop-daemon --start --quiet --pidfile \
            /var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS || true
        echo "$NAME."
        ;;
      reload)
            echo -n "Reloading $DESC configuration: "
            test_nginx_config
            start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/$NAME.pid \
                --exec $DAEMON || true
            echo "$NAME."
            ;;
      configtest)
            echo -n "Testing $DESC configuration: "
            if test_nginx_config
            then
              echo "$NAME."
            else
              exit $?
            fi
            ;;
      status)
        status_of_proc -p /var/run/$NAME.pid "$DAEMON" nginx && exit 0 || exit $?
        ;;
      *)
        echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest}" >&2
        exit 1
        ;;
    esac
    
    exit 0

Set nginx to run on startup.

    sudo update-rc.d -f nginx defaults

The configuration for orstrings.org in `/etc/nginx/sites-available` is:

    upstream orstrings {
      server unix:///opt/orstrings/production/shared/tmp/sockets/puma.sock;
    }
    
    server {
      # listen 80;
      server_name orstrings.org www.orstrings.org;
      root /opt/orstrings/production/current/public;
    
      try_files $uri/index.html $uri @orstrings;
    
      location @orstrings {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_redirect off;
    
        proxy_pass http://orstrings;
      }
    
      error_page 500 504 /500.html;
      error_page 502 /502.html;
      error_page 503 /503.html;
    
      #client_max_body_size 4G;
      keepalive_timeout 10;
    }

Activate it by symlinking from `/etc/nginx/sites-enabled`:

    cd /etc/nginx/sites-enabled
    sudo ln -s ../sites-available/orstrings.org 10-orstrings.org

RBenv
-----

Switch to the application user (orstrings) and install rbenv and ruby-build to `~orstrings/.rbenv`:

    cd
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

Update `~orstrings/.profile` to get rbenv in the `PATH` and set `RAILS_ENV=production`:

    export RAILS_ENV=production
    
    # RBEnv
    if [[ -d "$HOME/.rbenv" ]] ; then
      export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
    fi

Install the desired Ruby and set as the global Ruby for orstrings:

    rbenv install 1.9.3-p429
    rbenv global 1.9.3-p429

Life is simplier if Rails and a JavaScript intepreter are installed at this point so Bundler and its dependencies are available.

    gem install rails --version=3.2.14

For JavaScript, install Node.JS

    ## Install Node.JS to precompile assets on deploy
    apt-get install python-software-properties python g++ make
    add-apt-repository ppa:chris-lea/node.js
    apt-get update
    apt-get install nodejs

Puma
----

Install the Puma gem to orstrings' environment:

    gem install puma

Since Puma is not in the system path, the typical "Jungle" scripts need to be modified.  Create `/usr/local/bin/run-puma-rbenv`

    app=$1; config=$2; log=$3;
    user=$(whoami)
    export PATH="~$user/.rbenv/shims:~$user/.rbenv/bin:$PATH"
    cd $app && exec bundle exec puma -C $config 2>&1 >> $log

The pumactl script is sometimes run as root from `/etc/init.d/puma` so a wrapper hook the app user's rbenv environment in is necessary.  Create `/usr/local/bin/run-pumactl-rbenv`

    #!/bin/bash
    dir="$1" ; shift
    user="$1" ; shift
    export PATH="~$user/.rbenv/shims:~$user/.rbenv/bin:$PATH"
    cd $dir && pumactl $@

Finally, `/etc/init.d/puma` needs the following modifications from the version that ships as part of the Jungle Tools:

    diff --git a/opt/orstrings/.rbenv/versions/1.9.3-p429/lib/ruby/gems/1.9.1/gems/puma-2.5.1/tools/jungle/init.d/puma
    index 8bcee58..f0fd422 100755
    --- a/opt/orstrings/.rbenv/versions/1.9.3-p429/lib/ruby/gems/1.9.1/gems/puma-2.5.1/tools/jungle/init.d/puma
    +++ b/etc/init.d/puma
    @@ -22,7 +22,8 @@ DAEMON=$NAME
     SCRIPTNAME=/etc/init.d/$NAME
     CONFIG=/etc/puma.conf
     JUNGLE=`cat $CONFIG`
    -RUNPUMA=/usr/local/bin/run-puma
    +RUNPUMA=/usr/local/bin/run-puma-rbenv
    +RUNPUMACTL=/usr/local/bin/run-pumactl-rbenv
    
     # Load the VERBOSE setting and other rcS variables
     . /lib/init/vars.sh
    @@ -90,13 +91,16 @@ do_stop_one() {
       log_daemon_msg "--> Stopping $1"
       PIDFILE=$1/tmp/puma/pid
       STATEFILE=$1/tmp/puma/state
    +  i=`grep $1 $CONFIG`
    +  dir=`echo $i | cut -d , -f 1`
    +  user=`echo $i | cut -d , -f 2`
       if [ -e $PIDFILE ]; then
         PID=`cat $PIDFILE`
         if [ "`ps -A -o pid= | grep -c $PID`" -eq 0 ]; then
           log_daemon_msg "---> Puma $1 isn't running."
         else
           log_daemon_msg "---> About to kill PID `cat $PIDFILE`"
    -      pumactl --state $STATEFILE stop
    +      $RUNPUMACTL $dir $user --state $STATEFILE stop
           # Many daemons don't delete their pidfiles when they exit.
           rm -f $PIDFILE $STATEFILE
         fi
    @@ -123,10 +127,11 @@ do_restart_one() {
       PIDFILE=$1/tmp/puma/pid
       i=`grep $1 $CONFIG`
       dir=`echo $i | cut -d , -f 1`
    +  user=`echo $i | cut -d , -f 2`
    
       if [ -e $PIDFILE ]; then
         log_daemon_msg "--> About to restart puma $1"
    -    pumactl --state $dir/tmp/puma/state restart
    +    $RUNPUMACTL $dir $user --state $dir/tmp/puma/state restart
         # kill -s USR2 `cat $PIDFILE`
         # TODO Check if process exist
       else
    @@ -162,10 +167,11 @@ do_status_one() {
       PIDFILE=$1/tmp/puma/pid
       i=`grep $1 $CONFIG`
       dir=`echo $i | cut -d , -f 1`
    +  user=`echo $i | cut -d , -f 2`
    
       if [ -e $PIDFILE ]; then
         log_daemon_msg "--> About to status puma $1"
    -    pumactl --state $dir/tmp/puma/state stats
    +    $RUNPUMACTL $dir $user --state $dir/tmp/puma/state stats
         # kill -s USR2 `cat $PIDFILE`
         # TODO Check if process exist
       else

Finally, add the orstrings application to the jungle:

    sudo /etc/init.d/puma add /opt/orstrings/production/current orstrings

PostgreSQL
----------

Nothing out of the ordinary here.  Create a database and user via psql:

    sudo -u postgres psql
    CREATE ROLE orstrings WITH LOGIN PASSWORD '********';
    CREATE DATABASE orstrings_production WITH OWNER orstrings ENCODING 'UTF8';

Capistrano
----------

After running `deploy:setup`, add a directory to hold the Puma PIDs and state files -- from orstrings home directory:

    mkdir -p production/shared/tmp/puma

Also write a database configuration to `production/shared/config/database.yml`

    production:
      adapter: postgresql
      database: orstrings_production
      username: orstrings
      password: ********
      host: localhost