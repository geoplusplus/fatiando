# Build, package and clean Fatiando
PY := python
PIP := pip
NOSE := nosetests

help:
	@echo "Commands:"
	@echo ""
	@echo "    develop       build and force pip install a development version (calls Cython)"
	@echo "    build         build the extension modules inplace"
	@echo "    cython        generate C code from Cython files before building"
	@echo "    docs          build the html documentation"
	@echo "    view-docs     serve the docs html on http://127.0.0.1:8008"
	@echo "    linkcheck     check the docs for broken links"
	@echo "    test          run the test suite (including doctests)"
	@echo "    pep8          check for PEP8 style compliance"
	@echo "    pep8-stats    print a summary of the PEP8 check"
	@echo "    coverage      calculate test coverage using Coverage"
	@echo "    package       create source distributions"
	@echo "    clean         clean up build and generated files"
	@echo "    clean-docs    clean up the docs build"
	@echo ""

.PHONY: build
build:
	$(PY) setup.py build_ext --inplace

cython:
	$(PY) setup.py build_ext --inplace --cython

develop:
	$(PY) setup.py build --cython
	pip install --no-deps --ignore-installed .

docs:
	make -C doc all

linkcheck:
	make -C doc linkcheck

view-docs:
	make -C doc serve

.PHONY: test
test: build
	$(NOSE) --with-doctest -v fatiando test/

coverage: build
	$(NOSE) --with-doctest --with-coverage --cover-package=fatiando fatiando/ \
		test/

pep8:
	pep8 --show-source --ignore=W503,E226,E241\
		--exclude=_version.py fatiando test cookbook setup.py

pep8-stats:
	pep8 --exclude=_version.py --statistics -qq fatiando test cookbook setup.py

package:
	$(PY) setup.py sdist --formats=zip,gztar

clean:
	find . -name "*.so" -exec rm -v {} \;
	find . -name "*.pyc" -exec rm -v {} \;
	rm -rvf build dist MANIFEST
	# Trash generated by the doctests
	rm -rvf mydata.txt mylogfile.log
	# The stuff fetched by the cookbook recipes
	rm -rvf logo.png cookbook/logo.png
	rm -rvf crust2.tar.gz cookbook/crust2.tar.gz
	rm -rvf bouguer_alps_egm08.grd cookbook/bouguer_alps_egm08.grd
	rm -rvf *.gdf cookbook/*.gdf
	make -C doc clean
