all: out/index.xhtml
clean:
	rm -rf ../../.tools/rr.war ../../.tools/ebnf-convert.war Expression.ebnf out out.zip

../../.tools/rr.war:
	mkdir -p ../../.tools
	curl -L -o ../../.tools/rr.war https://repo1.maven.org/maven2/de/bottlecaps/rr/rr-webapp/2.6/rr-webapp-2.6.war

../../.tools/ebnf-convert.war:
	mkdir -p ../../.tools
	curl -L -o ../../.tools/ebnf-convert.war https://repo1.maven.org/maven2/de/bottlecaps/ebnf-convert/ebnf-convert-webapp/0.73/ebnf-convert-webapp-0.73.war

Expression.ebnf: ../../.tools/ebnf-convert.war ../Expression.g4
	java -Djava.awt.headless=true -jar ../../.tools/ebnf-convert.war ../Expression.g4 > $@

out/index.xhtml: ../../.tools/rr.war Expression.ebnf
	java -Djava.awt.headless=true -jar ../../.tools/rr.war -color:#dedede -noembedded Expression.ebnf > out.zip
	unzip -o out.zip -d out
	rm out.zip
	for f in out/diagram/*.svg; do \
	  filename=$$(basename "$$f" .svg); \
		rsvg-convert -z 10 -o out/diagram/$$filename.png "$$f"; \
	done
