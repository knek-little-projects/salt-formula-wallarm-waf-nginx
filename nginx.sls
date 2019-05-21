{% set wallarm = pillar['wallarm']['nginx']['auth'] %}

/etc/apt/sources.list.d/wallarm.list:
  file.managed:
    - source: salt://wallarm/files/wallarm.list

/etc/apt/trusted.gpg.d/wallarm.gpg:
  file.managed:
    - source: salt://wallarm/files/wallarm.gpg

/etc/nginx/conf.d/wallarm.conf:
  file.managed:
    - source: salt://wallarm/templates/nginx.conf.d/wallarm.jinja
    - template: jinja
    - makedirs: True
    - require_in:
      - service: nginx

/etc/nginx/conf.d/wallarm-status.conf:
  file.managed:
    - source: salt://wallarm/templates/nginx.conf.d/wallarm-status.jinja
    - template: jinja
    - makedirs: True
    - require_in:
      - service: nginx

wallarm-node-nginx:
  pkg.latest:
    - refresh: True
    - install_recommends: False
    - require:
      - file: /etc/apt/sources.list.d/wallarm.list
      - file: /etc/apt/trusted.gpg.d/wallarm.gpg
    - require_in:
      - service: nginx

nginx-module-wallarm:
  pkg.latest:
    - refresh: True
    - install_recommends: False
    - require:
      - file: /etc/apt/sources.list.d/wallarm.list
      - file: /etc/apt/trusted.gpg.d/wallarm.gpg
    - require_in:
      - service: nginx

wallarm_addnode:
  cmd.run:
    - name: /usr/share/wallarm-common/addnode -u "{{ wallarm.get('username') }}" -p "{{ wallarm.get('password') }}" -n "{{ wallarm.get('node') }}" -f
    - unless: test -f /etc/wallarm/node.yaml
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

# https://docs.wallarm.com/en/admin-en/installation-nginx-en.html#5-connect-the-wallarm-module
# Add `load_module modules/ngx_http_wallarm_module.so` right after the `worker_processes` directive
update_config:
  file.line:
    - name: /etc/nginx/nginx.conf
    - mode: insert
    - content: load_module modules/ngx_http_wallarm_module.so;
    - after: 'worker_processes.*;'
    - require:
      - file: /etc/nginx
