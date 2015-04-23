{% from "nginx/map.jinja" import nginx as nginx_map with context %}

upload_progress_conf:
  file.managed:
    - name: {{ nginx_map.conf_dir }}/conf.d/upload_progress.conf
    - template: jinja
    - source: salt://nginx/templates/upload_progress.jinja
    - user: root
    - group: root
    - mode: "0644"
    - watch_in:
      - service: nginx