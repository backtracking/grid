
all:
	dune build

test:
	dune runtest

doc:
	dune build @doc

install:
	dune install

clean:
	dune clean
