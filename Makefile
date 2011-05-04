all: main.exe

OPA_COMP = opa
OPA_ARGS =
OPADOC = opadoc

OPA = $(OPA_COMP) $(OPA_ARGS)
OPADOCAPI = $(OPA_COMP) --api-only

PACK = src/twopenny.opack

SRC = $(addprefix src/, $(shell cat $(PACK)))

main.exe: $(PACK) $(SRC)
	$(OPA) $< -o $@

run: main.exe
	./main.exe

run.debug: main.exe
	./main.exe --db-force-upgrade --debug-editable-js --js-cleaning no --js-renaming no

doc: $(SRC) clean
	$(OPADOCAPI) $(SRC)
	$(OPADOC) src
	@firefox doc/index.html &

clean:
	rm -rf *.opx *.opx.broken *.exe _tracks _build opa-debug *.log src/*.api* opadoc.apix
