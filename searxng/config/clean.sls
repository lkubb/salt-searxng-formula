# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as searxng with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
SearXNG environment files are absent:
  file.absent:
    - names:
      - {{ searxng.lookup.paths.config_searxng }}
      - {{ searxng.lookup.paths.config_redis }}
      - {{ searxng.lookup.paths.config }}
      - {{ searxng.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
