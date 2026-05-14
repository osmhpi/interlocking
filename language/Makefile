all: parser

ANTLR_BIN := $(shell which antlr 2>/dev/null || which antlr4)

clean:
	rm -f ../codegen/Parser/*.interp

parser: ../codegen/Parser/Expression.interp ../codegen/Parser/Graph.interp

../codegen/Parser/%.interp: %.g4
	$(ANTLR_BIN) -visitor -Dlanguage=CSharp -o ../codegen/Parser $<

../codegen/Parser/Graph.interp: Expression.g4
