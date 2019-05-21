{% set wallarm = pillar['wallarm']['tarantool']['auth'] %}

/etc/apt/sources.list.d/wallarm.list:
  file.managed:
    - source: salt://wallarm/files/wallarm.list

/etc/apt/trusted.gpg.d/wallarm.gpg:
  file.managed:
    - source: salt://wallarm/files/wallarm.gpg

/etc/default/wallarm-tarantool:
  file.managed:
    - source: salt://wallarm/templates/tarantool/wallarm-tarantool.jinja
    - makedirs: True
    - template: jinja

wallarm-node-tarantool:
  pkg.latest:
    - refresh: True
    - install_recommends: False
    - require:
      - file: /etc/apt/sources.list.d/wallarm.list
      - file: /etc/apt/trusted.gpg.d/wallarm.gpg
  service.running:
    - name: wallarm-tarantool
    - enable: True
    - reload: True
    - require:
      - pkg: wallarm-node-tarantool
      - file: /etc/default/wallarm-tarantool
    - watch:
      - cmd: wallarm_addnode

wallarm_addnode:
  cmd.run:
    - name: /usr/share/wallarm-common/addnode -u "{{ wallarm.get('username') }}" -p "{{ wallarm.get('password') }}" -n "{{ wallarm.get('node') }}" -f
    - unless: test -f /etc/wallarm/node.yaml
    - require:
      - pkg: wallarm-node-tarantool