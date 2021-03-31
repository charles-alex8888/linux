  ~~~ bash
   listen 443 ssl;
   server_name  wgcdn.wgnice.com;
   ssl_certificate      /usr/local/nginx/cert/START-wgnice-com.pem;
   ssl_certificate_key  /usr/local/nginx/cert/START-wgnice-com.key;
   ssl_session_cache    shared:SSL:1m;
   ssl_session_timeout  5m;
   ssl_ciphers  HIGH:!aNULL:!MD5;
   ssl_prefer_server_ciphers  on;
   ~~~
