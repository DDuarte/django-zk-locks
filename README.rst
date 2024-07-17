=====================
django-zookeeper-locks
=====================

.. image:: https://github.com/DDuarte/django-zookeeper-locks/workflows/tests/badge.svg
    :target: https://github.com/DDuarte/django-zookeeper-locks/actions?query=workflow%3Atests
    :alt: tests

.. image:: https://codecov.io/gh/DDuarte/django-zookeeper-locks/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/DDuarte/django-zookeeper-locks
   :alt: Test coverage status

.. image:: https://img.shields.io/pypi/v/django-zookeeper-locks
    :target: https://pypi.org/project/django-zookeeper-locks/
    :alt: Current version on PyPi

.. image:: https://img.shields.io/pypi/dm/django-zookeeper-locks
    :target: https://pypi.org/project/django-zookeeper-locks/
    :alt: monthly downloads

.. image:: https://img.shields.io/pypi/pyversions/django-zookeeper-locks
    :alt: PyPI - Python Version

.. image:: https://img.shields.io/pypi/djversions/django-zookeeper-locks
    :alt: PyPI - Django Version

Distributed locks for Django using Zookeeper

Installation
------------

    pip install django-zookeeper-locks


Usage
-----

`django-zookeeper-locks` exposes one single the `lock` contextmanager and the `locked` decorator.

The `locked` decorator will wrap a django management command (subclasses of `django.core.management.base.BaseCommand`) or any function with the `lock` contextmanager:


.. code-block:: python

    from django.core.management.base import BaseCommand

    from database_locks import locked

    @locked
    class Command(BaseCommand):
        ...
        def handle(self, *args, **options):
            self.stdout.write('Got the lock')


.. code-block:: python

    from database_locks import locked
    
    class SomeClass:
      def non_locked(self):
        pass
      
      @locked
      def locked(self):
        print('got lock')

.. code-block:: python

    from database_locks import lock
    
    class SomeClass:
      def non_locked(self):
        pass
      
      def locked(self):
        with lock():
            print('got lock')

Docs
----

Both `lock` and `locked` have the same optional args:

.. code-block:: python

    :param lock_name: unique name in DB for this function

There are also the following options you can specify in the project `settings.py`

- *ZOOKEEPER_LOCKS_STATUS_FILE*: file that will be updated with the lock status (default `None`). Useful when you have multiple shared-lock processes, to quickly inspect which one has the lock.
- *ZOOKEEPER_LOCKS_ENABLED*: set to `False` to globally disable locks (default `True`)
- *ZOOKEEPER_LOCKS_HOSTS*: connection string for Zookeeper, such as "localhost:2181,localhost:2182,localhost:2183"


Testing
-------

Tox is used by the Github Action to test several python and django versions.

To quickly test locally, kick off a Zookeeper docker container:


    docker run -d --name locks-test \
               -p 2181:2181 \
               zookeeper:3.9

List available environments with `tox -l` and then run the one you want/have:

    tox -e py310-dj42
