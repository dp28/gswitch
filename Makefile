SHELL := /bin/bash
all: install

install:	
	cp bin/gswitch /usr/local/bin/
	cp -r lib/ /usr/local/lib/gswitch
	./bin/add_gswitch_completion
	# GSwitch installation complete, try it with 'gswitch -h'.