# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}

searxng service is dead:
  compose.dead:
    - name: {{ searxng.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if searxng.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ searxng.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
{%- endif %}

searxng service is disabled:
  compose.disabled:
    - name: {{ searxng.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if searxng.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ searxng.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
{%- endif %}
