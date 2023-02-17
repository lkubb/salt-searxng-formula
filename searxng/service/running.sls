# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}

include:
  - {{ sls_config_file }}

SearXNG service is enabled:
  compose.enabled:
    - name: {{ searxng.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if searxng.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ searxng.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - SearXNG is installed
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
{%- endif %}

SearXNG service is running:
  compose.running:
    - name: {{ searxng.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if searxng.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ searxng.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
{%- endif %}
    - watch:
      - SearXNG is installed
      - SearXNG settings are managed
