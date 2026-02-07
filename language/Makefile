all: parser

ANTLR_BIN := $(shell which antlr 2>/dev/null || which antlr4)

clean:
	rm -f ../codegen/InterlockingCodegen/*.interp

parser: ../codegen/InterlockingCodegen/Expression.interp ../codegen/InterlockingCodegen/Graph.interp

../codegen/InterlockingCodegen/%.interp: %.g4
	$(ANTLR_BIN) -visitor -Dlanguage=CSharp -o ../codegen/InterlockingCodegen $<

../codegen/InterlockingCodegen/Graph.interp: Expression.g4
