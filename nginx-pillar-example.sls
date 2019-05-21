wallarm:
  nginx:
    auth:
      username: "YOUR@EMAIL.com"
      password: "PASSWORD!"
      node: "demo-wallarm-nginx"
    status:
      listen: 8080
      server_name: stage.yourwebsite.com www.stage.yourwebsite.com
      wallarm_mode: 'off'
      access_log: 'off'
    tarantool-upstream:
      server: demo-wallarm-tarantool.yourwebsite.com:3313 max_fails=0 fail_timeout=0 max_conns=1
      keepalive: 1
    wallarm:
      wallarm_upstream_connect_attempts: 10
      wallarm_upstream_reconnect_interval: 15
      wallarm_mode: monitoring
      wallarm_mode_allow_override: 'on'
