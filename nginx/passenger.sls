{% set nginx = pillar.get('nginx', {}) -%}

get_passenger_deps:
  pkg.installed:
    - names:
      - ruby-dev
      - libcurl4-gnutls-dev

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
    - watch_in:
      - service: nginx
