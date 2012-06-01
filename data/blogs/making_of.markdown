
#Setting up Apache and OCaml locally

* Edit /etc/hosts;   
  *  Add the line `127.0.0.1	ocaml.com`  
* Edit /etc/apache2/extra/httpd-vhosts.conf  
<VirtualHost *:80>
  ServerName ocaml.com
  AddHandler cgi-script .cgi
  DocumentRoot "/Users/goggin/projects/ocaml/home"
  CustomLog "/Users/goggin/projects/ocaml/home/log/apache_access.log" common
  ErrorLog "/Users/goggin/projects/ocaml/home/log/apache_error.log" 
  <IfModule dir_module>
    DirectoryIndex index.cgi
  </IfModule>   
  <Directory /Users/goggin/projects/ocaml/home>
    Options +ExecCGI
    AllowOverride All 
    Order allow,deny 
    Allow from all
    RewriteEngine on 
    RewriteCond %{HTTP_COOKIE} (?:^|;\s*)(.*)=([^;]*)
    RewriteRule ^([a-z]+)?/?([a-z]+)?$	/index.cgi?controller=$1&view=$2&%1=%2 [L,QSA,NS]
    RewriteRule ^([a-z]+)?/?([a-z]+)?$	/index.cgi?controller=$1&view=$2 [L,QSA,NS]
  </Directory>
</VirtualHost>

