ALL_PUML_FILES := $(shell find generic_application/graphs -name "*.puml")
ALL_SVG_FILES := $(patsubst %.puml,%.svg,$(ALL_PUML_FILES))

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

all: web

clean:
	rm -f $(ALL_SVG_FILES)
	rm -f simulator/react/app/welcome/configuration.json
	make -C ../language clean

parser:
	make -C ../language parser

../.tools/plantuml.jar:
	mkdir -p ../.tools
	wget https://github.com/plantuml/plantuml/releases/download/v1.2026.1/plantuml-mit-1.2026.1.jar -O ../.tools/plantuml.jar

%.svg: %.puml ../.tools/plantuml.jar
	cat $*.puml | java -Djava.awt.headless=true -jar ../.tools/plantuml.jar -pipe --format svg > $@

puml: $(ALL_SVG_FILES)

generic_application_simulator/src/schedule.rs: parser $(ALL_PUML_FILES)
	cd ../codegen/InterlockingCodegen && dotnet run -- ../../$(CURRENT_DIR)

generic_application_simulator/pkg/interlocking.js: generic_application_simulator/src/schedule.rs
	cd generic_application_simulator && wasm-pack build --target bundler

wasm: generic_application_simulator/pkg/interlocking.js

web: generic_application_simulator/pkg/interlocking.js specific_application/configuration.json
	cp specific_application/configuration.json ../resources/simulator/app/welcome/configuration.json
	cp -r generic_application_simulator/pkg/ ../resources/simulator/interlocking/
	make -C ../resources/simulator web

build: generic_application_simulator/pkg/interlocking.js specific_application/configuration.json
	cp specific_application/configuration.json ../resources/simulator/app/welcome/configuration.json
	cp -r generic_application_simulator/pkg/ ../resources/simulator/interlocking/
	make -C ../resources/simulator build

dev: generic_application_simulator/pkg/interlocking.js specific_application/configuration.json
	cp specific_application/configuration.json ../resources/simulator/app/welcome/configuration.json
	cp -r generic_application_simulator/pkg/ ../resources/simulator/interlocking/
	make -C ../resources/simulator dev
