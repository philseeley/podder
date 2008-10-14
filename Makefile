all:
	@echo Specify one of deb or rpm

deb:
	./package-deb

rpm:
	./package-rpm

clean:
	rm -rf debian redhat
