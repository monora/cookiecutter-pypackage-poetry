.. highlight:: shell

============
Installation
============


Stable release
--------------

To install {{ cookiecutter.project_name }}, run this command in your terminal:

.. code-block:: console

    $ pip install {{ cookiecutter.project_name }}

This is the preferred method to install {{ cookiecutter.project_name }}, as it will always install the most recent stable release.

If you don't have `pip`_ installed, this `Python installation guide`_ can guide
you through the process.

.. _pip: https://pip.pypa.io
.. _Python installation guide: http://docs.python-guide.org/en/latest/starting/installation/


From sources
------------

The sources for {{ cookiecutter.project_name }} can be downloaded from the `Github repo`_.

You can either clone the public repository:

.. code-block:: console

    $ git clone git://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_name }}

Or download the `tarball`_:

.. code-block:: console

    $ curl  -OL https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_name }}/tarball/master

Once you have a copy of the source, you can install into poetry virtual environment with:

.. code-block:: console

    $ poetry install

If you in addition use `direnv` you must first allow direnv when you enter the project directory:

.. code-block:: console

    $ direnv allow

If you use `Intellij IDEA` you have to set the `Project SDK` to the virtual environment created by poetry, which is located here:

.. code-block:: console

    $ ls $HOME/.cache/pypoetry/virtualenvs/{{ cookiecutter.project_slug }}-py*/bin/python

.. _Github repo: https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_name }}
.. _tarball: https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_name }}/tarball/master
