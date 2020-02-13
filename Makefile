.PHONY: clean

assemble: build/warships.a2

all: build/warships.a2 build/warships.wav build/disk.dsk

build/warships.a2: deps/a2asm warships.6502
	mkdir -p build
	deps/a2asm warships.6502 >build/warships.a2

build/warships.wav: build/warships.a2 deps/c2t
	mkdir -p build
	deps/c2t/bin/c2t-96h -2 build/warships.a2 build/warships.wav

build/disk.dsk: build/warships.a2 deps/ac.jar deps/disk.dsk
	cp deps/disk.dsk build/disk.dsk
	java -jar deps/ac.jar -dos deps/disk.dsk WARSHIPS B <build/warships.a2

deps/ac.jar:
	mkdir -p deps
	curl -L 'https://github.com/AppleCommander/AppleCommander/releases/download/v1-5-0/AppleCommander-ac-1.5.0.jar' >deps/ac.jar

deps/disk.dsk:
	mkdir -p deps
	curl -L 'https://github.com/AppleWin/AppleWin/raw/master/bin/MASTER.DSK' >deps/disk.dsk

deps/a2asm:
	mkdir -p deps
	git clone https://github.com/taeber/a2asm deps/a2asm.git
	cd deps/a2asm.git && \
		go build -o ../a2asm cmd/a2asm/main.go

deps/c2t:
	mkdir -p deps
	git clone https://github.com/datajerk/c2t.git deps/c2t
	cd deps/c2t && \
		make

clean:
	rm -rf ./build/ ./deps/
