Wallarm SaltStack formula
=========================

Deploy Wallarm WAF nginx module and tarantool server with SaltStack

**Tested on Debian 9**. It may not work on other systems.


Deploy
------

* Setup pillars &ndash; see examples at `tarantool-pillar-example.sls` and `nginx-pillar-example.sls`
* Change pillar links
    * see variable `wallarm` at `tarantool.sls`
    * see variable `wallarm` at `nginx.sls`
    * see variable `config` at `templates/tarantool/wallarm-tarantool.jinja`
    * see variable `config` and `upstream` at `templates/nginx.conf.d/wallarm.jinja`
    * see variable `config` at `templates/nginx.conf.d/wallarm-status.jinja`
* Use `tarantools.sls` to install Wallarm Tarantool server on you system
* Use `nginx.sls` to install Wallarm NGINX Module to **existing** nginx server
    * **Make sure you use official NGINX repository**. Wallarm may not work with Debian default repository version of NGINX.
