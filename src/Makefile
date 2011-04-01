all: main.exe

OPA_COMP = s3opa.exe
OPA_ARGS =
OPA = $(OPA_COMP) $(OPA_ARGS)

SRC = $(shell cat twopenny.opack)

main.exe: twopenny.opack $(SRC)
	$(OPA) $< -o $@

run: main.exe
	./main.exe

run.debug: main.exe
	./main.exe --debug-editable-js --js-cleaning no --js-renaming no

clean:
	rm -rf *.opx *.opx.broken *.exe _tracks _build opa-debug *.log
