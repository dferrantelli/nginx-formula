{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

{% set geolib_version = nginx.get('geolib_version', {}) -%}
{% set geolib_checksum = nginx.get('geolib_checksum', {}) -%}
{% set geolib_home = nginx.get('geolib_home', {}) -%}


get_geolib:
  pkg.installed:
    - names:
      - eclipse-cdt-autotools
      - automake1.11
      - libgeoip1
  # file.managed:
  #   - name: {{ source }}/GeoIP-{{ geolib_version }}.tar.gz
  #   - source: http://geolite.maxmind.com/download/geoip/api/c/GeoIP-{{ geolib_version }}.tar.gz
  #   - source_hash: {{ geolib_checksum }}
  # cmd.wait:
  #   - cwd: {{ source }}
  #   - name: "tar -zxf GeoIP-{{ geolib_version }}.tar.gz && cd GeoIP-{{ geolib_version }} && ./configure && make && make install"
  #   - creates: /usr/lib/libGeoIP.so.{{ geolib_version }}
  #   - watch:
  #     - file: get_geolib
  #   - require:
  #     - package: get_geolib
  #   - require_in:
  #     - cmd: nginx

{{ geolib_home }}:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

get_geoip_country:
  cmd.run:
    - cwd: {{ geolib_home }}
    - name: wget {{ nginx.geoip.country_src }} && gunzip GeoIP.dat.gz
    - creates: {{ geolib_home }}/GeoIP.dat
    - require:
        - file: {{ geolib_home }}
    - require_in:
      - cmd: nginx

{% if nginx.get('geolib_cities', False) %}
get_geoip_city:
  cmd.run:
    - cwd: {{ geolib_home }}
    - name: wget {{ nginx.geoip.city_src }} && gunzip GeoLiteCity.dat.gz
    - creates: {{ geolib_home }}/GeoLiteCity.dat
    - require:
        - file: {{ geolib_home }}
    - require_in:
      - cmd: nginx
{% endif %}
