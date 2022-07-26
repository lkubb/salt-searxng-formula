# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}

include:
  - {{ sls_config_clean }}

SearXNG is absent:
  compose.removed:
    - name: {{ searxng.lookup.paths.compose }}
    - volumes: {{ searxng.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if searxng.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ searxng.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

SearXNG compose file is absent:
  file.absent:
    - name: {{ searxng.lookup.paths.compose }}
    - require:
      - SearXNG is absent

SearXNG user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ searxng.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ searxng.lookup.user.name }}

SearXNG user account is absent:
  user.absent:
    - name: {{ searxng.lookup.user.name }}
    - purge: {{ searxng.install.remove_all_data_for_sure }}
    - require:
      - SearXNG is absent
    - retry:
        attempts: 5
        interval: 2

{%- if searxng.install.remove_all_data_for_sure %}

SearXNG paths are absent:
  file.absent:
    - names:
      - {{ searxng.lookup.paths.base }}
    - require:
      - SearXNG is absent
{%- endif %}
