.PHONY: build

path:=$(shell echo `pwd` | rev | cut -d'/' -f1 | rev)
image = bdbstudios/$(path)
pubimage = bdbstudios/$(path)

build:
	docker build $(no-cache) -t "$(image)" .
	docker tag "$(image)" "$(pubimage)"
	docker run --rm "$(image)" bash -c 'python /home/tools/tests/tests.py'
