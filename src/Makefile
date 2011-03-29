all: main.exe

OPA_COMP = s3opa.exe
OPA_ARGS =
OPA = $(OPA_COMP) $(OPA_ARGS)

SRC = $(shell cat twopenny.opack)

main.exe: twopenny.opack $(SRC)
	$(OPA) $< -o $@

run: main.exe
	./main.exe

clean:
	rm -rf *.opx *.opx.broken *.exe _tracks
