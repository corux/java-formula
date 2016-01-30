{% from 'java/map.jinja' import java with context %}

jre-directory:
  file.directory:
    - name: {{ java.directory }}
    - clean: True

{% set installed = [] %}
{% for jre in java.get('install', []) %}
{% set j = java.get(jre) %}
{% if jre not in installed %}
{% do installed.append(jre) %}
{% endif %}

{{ java.directory }}/{{ j.home }}:
  file.directory:
    - name: {{ java.directory }}/{{ j.home }}
    - require_in:
      - file: jre-directory

{{ java.directory }}/{{ j.topleveldir }}:
  file.directory:
    - name: {{ java.directory }}/{{ j.topleveldir }}
    - require_in:
      - file: jre-directory
{% endfor %}
