# -*- coding: utf-8 -*-
# vim: ft=yaml
---
searxng:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: searxng
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/searxng
      compose: docker-compose.yml
      config_searxng: searxng.env
      config_redis: redis.env
      config: config
    user:
      groups: []
      home: null
      name: searxng
      shell: /usr/sbin/nologin
      uid: null
    containers:
      redis:
        image: docker.io/library/redis:alpine
      searxng:
        image: docker.io/searxng/searxng:latest
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    general:
      instance_name: SearXNG
    redis:
      url: redis://redis:6379/0
    search:
      autocomplete: ''
    server:
      base_url: http://localhost/
      image_proxy: true
      limiter: true
      port: '5346'
      secret_key: null
    ui:
      static_use_hash: true
    use_default_settings: true

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://searxng/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   searxng-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      SearXNG environment file is managed:
      - searxng.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
