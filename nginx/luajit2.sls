{% set nginx = pillar.get('nginx', {}) -%}
{% set nginx_home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

luajit_src_dir:
  file.directory:
    - name: {{ source }}/luajit
    - makedirs: True

get-luajit2:
  file.managed:
    - name: {{ source }}/luajit.tar.gz
    - source: http://luajit.org/download/LuaJIT-2.0.1.tar.gz
    - source_hash: sha1=330492aa5366e4e60afeec72f15e44df8a794db5
  cmd.wait:
    - cwd: {{ source }}
    - name: tar --strip 1 -zxf luajit.tar.gz -C luajit && cd luajit && make && make install
    - watch:
      - file: get-luajit2
    - require_in:
      - cmd: nginx
    - require:
      - file: luajit_src_dir
      - file: get-luajit2
  pkg.installed:
    - names: 
      - liblua5.1-0-dev
      - libluajit-5.1-dev
      - lua5.1