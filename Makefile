.PHONY: flake8 test coverage style style_check

style:
	black --target-version=py310 zookeeper_locks tests setup.py
	flake8 zookeeper_locks tests

style_check:
	black --target-version=py310 --check zookeeper_locks tests setup.py

flake8:
	flake8 zookeeper_locks tests

startzk:
	docker inspect django-zookeeper-locks-zk | grep '"Running": true' || \
		docker run --name django-zookeeper-locks-zk \
		           --rm -p 2181:2181 -d \
				   zookeeper:3.9

test: startzk
	DJANGO_SETTINGS_MODULE=settings \
		tests/manage.py test $${TEST_ARGS:-tests}

testcover: export DJANGO_SETTINGS_MODULE=settings
testcover: startzk
testcover: coverage

coverage:
	python --version
	coverage erase
	PYTHONPATH="tests" \
		python -b -W always -m coverage run tests/manage.py test $${TEST_ARGS:-tests}
	coverage report
