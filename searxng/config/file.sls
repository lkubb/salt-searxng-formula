# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

SearXNG environment files are managed:
  file.managed:
    - names:
      - {{ searxng.lookup.paths.config_searxng }}:
        - source: {{ files_switch(['searxng.env', 'searxng.env.j2'],
                                  lookup='searxng environment file is managed',
                                  indent_width=10,
                     )
                  }}
      - {{ searxng.lookup.paths.config_redis }}:
        - source: {{ files_switch(['redis.env', 'redis.env.j2'],
                                  lookup='redis environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ searxng.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ searxng.lookup.user.name }}
    - watch_in:
      - SearXNG is installed
    - context:
        searxng: {{ searxng | json }}

SearXNG settings are managed:
  file.serialize:
    - name: {{ searxng.lookup.paths.config | path_join("settings.yml") }}
    - serializer: yaml
    # this needs to be world-readable, otherwise the container
    # fails to start
    - mode: '0644'
    - user: root
    - group: {{ searxng.lookup.user.name }}
    - dataset: {{ searxng.config | json }}
