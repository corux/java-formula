{% from 'java/map.jinja' import java with context %}

{% if java.install %}
{% for key, val in java.get('trusted_certs', {}).items() %}
import-cert-{{ key }}:
  file.managed:
    - name: /tmp/jrecert-{{ key }}.crt
    - makedirs: True
    - contents: |
        {{ val|indent(8) }}
{% endfor %}

{% set installed = [] %}
{% for jre in java.install %}
{% set j = java.get(jre) %}
{% if jre not in installed %}
{% do installed.append(jre) %}

jre-{{ jre }}:
  archive.extracted:
    - name: {{ java.directory }}
    - source: {{ j.url }}
    - source_hash: {{ j.url_hash }}
    - if_missing: {{ java.directory }}/{{ j.topleveldir }}
    - require:
      - file: jre-extractdir

  file.symlink:
    - name: {{ j.home }}
    - target: {{ java.directory }}/{{ j.topleveldir }}
    - require:
      - file: jre-extractdir
      - archive: jre-{{ jre }}

jre-chmod-{{ jre }}:
  file.directory:
    - name: {{ java.directory }}
    - user: root
    - group: root
    - require:
      - file: jre-extractdir
      - archive: jre-{{ jre }}
    - recurse:
      - user
      - group

{% for key, val in java.get('trusted_certs', {}).items() %}
import-cert-{{ jre }}-{{ key }}:
  cmd.run:
    - name: ./bin/keytool -keystore {{ j.home }}/lib/security/cacerts -storepass changeit -noprompt -importcert -file /tmp/jrecert-{{ key }}.crt -alias {{ key }}
    - unless: ./bin/keytool -keystore {{ j.home }}/lib/security/cacerts -storepass changeit -noprompt -list -alias {{ key }}
    - cwd: {{ j.home }}
    - require:
      - file: import-cert-{{ key }}
      - file: jre-{{ jre }}
{% endfor %}
{% endif %}
{% endfor %}

jre-extractdir:
  file.directory:
    - name: {{ java.directory }}
    - makedirs: True
{% endif %}
