{% set nginx = pillar.get('nginx', {}) -%}
{% from "nginx/map.jinja" import nginx as nginx_map with context %}

get_passenger_deps:
  pkg.installed:
    - names:
      - ruby-dev

nginx_conf_d_dir_present:
  file.directory:
    - name: {{ nginx_map.conf_dir }}/conf.d

install_passenger:
  gem.installed:
    - name: passenger
    - version: {{ nginx.passenger.version }}
  file.managed:
    - name: /etc/nginx/conf.d/passenger.conf
    - template: jinja
    - source: salt://nginx/templates/passenger.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - context:
        root: {{ nginx.passenger.root }}
        version: {{ nginx.passenger.version }}
        ruby: {{ nginx.passenger.ruby }}
        spawn_method: {{ nginx.passenger.spawn_method }}
        buffer_response: {{ nginx.passenger.buffer_response }}
        max_pool_size: {{ nginx.passenger.max_pool_size }}
        min_instances: {{ nginx.passenger.min_instances }}
        max_instances_per_app: {{ nginx.passenger.max_instances_per_app }}
        pool_idle_time: {{ nginx.passenger.pool_idle_time }}
        max_requests: {{ nginx.passenger.max_requests }}
    - watch_in:
      - service: nginx
    - require:
      - file: nginx_conf_d_dir_present
