cython-file := streaming_form_data/_parser.pyx

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf streaming_form_data.egg-info

#
# Development
#

annotate:
	cython -a $(cython-file) -o build/annotation.html

compile:
	cython $(cython-file)

test:
	flake8
	py.test

update-deps:
	pip-compile requirements.dev.in > requirements.dev.txt

install-deps:
	pip install -r requirements.dev.txt

build:
	python setup.py build_ext --inplace

local: install-deps build

#
# Utils
#

speed-test:
	python utils/speedtest.py

profile:
	python utils/profile.py --data-size 17555000 -c binary/octet-stream

#
# PyPI
#

dist:
	python setup.py sdist

publish: dist
	twine upload dist/*

.PHONY: clean \
	annotate compile test \
	speed-test profile \
	update-deps install-deps build local \
	dist publish
