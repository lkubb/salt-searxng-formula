# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

SearXNG user account is present:
  user.present:
{%- for param, val in searxng.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ searxng.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

SearXNG user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ searxng.lookup.user.name }}
    - enable: {{ searxng.install.rootless }}
    - require:
      - user: {{ searxng.lookup.user.name }}

SearXNG paths are present:
  file.directory:
    - names:
      - {{ searxng.lookup.paths.base }}
      - {{ searxng.lookup.paths.config }}
    - user: {{ searxng.lookup.user.name }}
    - group: {{ searxng.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ searxng.lookup.user.name }}

{%- if searxng.install.podman_api %}

SearXNG podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman
    - user: {{ searxng.lookup.user.name }}
    - require:
      - SearXNG user session is initialized at boot

SearXNG podman API is available:
  compose.systemd_service_running:
    - name: podman
    - user: {{ searxng.lookup.user.name }}
    - require:
      - SearXNG user session is initialized at boot
{%- endif %}

SearXNG compose file is managed:
  file.managed:
    - name: {{ searxng.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="SearXNG compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ searxng.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        searxng: {{ searxng | json }}

SearXNG is installed:
  compose.installed:
    - name: {{ searxng.lookup.paths.compose }}
{%- for param, val in searxng.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in searxng.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ searxng.lookup.paths.compose }}
{%- if searxng.install.rootless %}
    - user: {{ searxng.lookup.user.name }}
    - require:
      - user: {{ searxng.lookup.user.name }}
{%- endif %}

{%- if searxng.install.autoupdate_service is not none %}

Podman autoupdate service is managed for SearXNG:
{%-   if searxng.install.rootless %}
  compose.systemd_service_{{ "enabled" if searxng.install.autoupdate_service else "disabled" }}:
    - user: {{ searxng.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if searxng.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
