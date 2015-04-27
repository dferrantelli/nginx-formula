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
