# vim: ft=sls

{#-
    Starts the searxng, redis container services
    and enables them at boot time.
    Has a dependency on `searxng.config`_.
#}

include:
  - .running
