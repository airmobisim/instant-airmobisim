.PHONY: clean all

all: instant-airmobisim.json
	./build.sh

clean:
	rm -fr output

