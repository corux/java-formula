{% from 'java/map.jinja' import java with context %}

java-env:
  file.managed:
    - name: /etc/profile.d/java.sh
    - mode: 644
    - user: root
    - group: root
    - contents: |
        export JAVA_HOME={{ java.get(java.env).home }}
        export PATH=$JAVA_HOME/bin:$PATH
