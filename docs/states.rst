Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``searxng``
^^^^^^^^^^^
*Meta-state*.

This installs the searxng, redis containers,
manages their configuration and starts their services.


``searxng.package``
^^^^^^^^^^^^^^^^^^^
Installs the searxng, redis containers only.
This includes creating systemd service units.


``searxng.config``
^^^^^^^^^^^^^^^^^^
Manages the configuration of the searxng, redis containers.
Has a dependency on `searxng.package`_.


``searxng.service``
^^^^^^^^^^^^^^^^^^^
Starts the searxng, redis container services
and enables them at boot time.
Has a dependency on `searxng.config`_.


``searxng.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``searxng`` meta-state
in reverse order, i.e. stops the searxng, redis services,
removes their configuration and then removes their containers.


``searxng.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the searxng, redis containers
and the corresponding user account and service units.
Has a depency on `searxng.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``searxng.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the searxng, redis containers
and has a dependency on `searxng.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``searxng.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the searxng, redis container services
and disables them at boot time.


