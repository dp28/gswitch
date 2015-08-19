SHELL := /bin/bash
all: install

reinstall: uninstall install

install:
	cp bin/gswitch /usr/local/bin/
	cp -r lib/ /usr/local/lib/gswitch
	./bin/add_gswitch_completion
	# GSwitch installation complete, try it with 'gswitch -h'.

uninstall:
	rm /usr/local/bin/gswitch
	rm -rf /usr/local/lib/gswitch