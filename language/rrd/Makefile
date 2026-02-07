all: out/index.xhtml
clean:
	rm -rf rr.war ebnf-convert.war Expression.ebnf out out.zip

rr.war:
	curl -L -o rr.war https://repo1.maven.org/maven2/de/bottlecaps/rr/rr-webapp/2.6/rr-webapp-2.6.war

ebnf-convert.war:
	curl -L -o ebnf-convert.war https://repo1.maven.org/maven2/de/bottlecaps/ebnf-convert/ebnf-convert-webapp/0.73/ebnf-convert-webapp-0.73.war

Expression.ebnf: ebnf-convert.war ../Expression.g4
	java -jar ebnf-convert.war ../Expression.g4 > $@

out/index.xhtml: rr.war Expression.ebnf
	java -jar rr.war -color:#dedede -noembedded Expression.ebnf > out.zip
	unzip -o out.zip -d out
	rm out.zip
	for f in out/diagram/*.svg; do \
	  filename=$$(basename "$$f" .svg); \
		rsvg-convert -z 10 -o out/diagram/$$filename.png "$$f"; \
	done
