{% set nginx = pillar.get('nginx', {}) -%}
{% from "nginx/map.jinja" import nginx as nginx_map with context %}

get_passenger_deps:
  pkg.installed:
    - names:
      - ruby-dev

nginx_conf_d_dir_present:
  file.directory:
    - name: {{ nginx.conf_dir }}/conf.d

install_passenger:
  gem.installed:
    - name: passenger
    - version: {{ nginx_map.passenger.version }}
  file.managed:
    - name: /etc/nginx/conf.d/passenger.conf
    - template: jinja
    - source: salt://nginx/templates/passenger.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - context:
        root: {{ nginx_map.passenger.root }}
        version: {{ nginx_map.passenger.version }}
        ruby: {{ nginx_map.passenger.ruby }}
        spawn_method: {{ nginx_map.passenger.spawn_method }}
        buffer_response: {{ nginx_map.passenger.buffer_response }}
        max_pool_size: {{ nginx_map.passenger.max_pool_size }}
        min_instances: {{ nginx_map.passenger.min_instances }}
        max_instances_per_app: {{ nginx_map.passenger.max_instances_per_app }}
        pool_idle_time: {{ nginx_map.passenger.pool_idle_time }}
        max_requests: {{ nginx_map.passenger.max_requests }}
    - watch_in:
      - service: nginx
    - require:
      - file: nginx_conf_d_dir_present
