all: deb

deb:
	./package-deb

clean:
	rm -rf debian
