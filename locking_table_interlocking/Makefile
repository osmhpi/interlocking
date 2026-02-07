.PHONY: simulator

ALL_PUML_FILES := $(shell find generic_application/graphs -name "*.puml")
ALL_SVG_FILES := $(patsubst %.puml,%.svg,$(ALL_PUML_FILES))

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

simulator: parser
	cd ../codegen/InterlockingCodegen && dotnet run -- ../../locking_table_interlocking

wasm: simulator
	cd simulator && wasm-pack build --target bundler

simulator/react/app/welcome/configuration.json: specific_application/configuration.json
	cp specific_application/configuration.json simulator/react/app/welcome/configuration.json

simulator/react/node_modules: simulator/react/package.json simulator/react/package-lock.json
	cd simulator/react && npm ci

web: wasm simulator/react/app/welcome/configuration.json simulator/react/node_modules
	cd simulator/react && npm run build && npm run start

build: wasm simulator/react/app/welcome/configuration.json simulator/react/node_modules
	cd simulator/react && npm run build

dev: wasm simulator/react/app/welcome/configuration.json simulator/react/node_modules
	cd simulator/react && npm run dev
