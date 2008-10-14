Name:		podder
Version:	__VERSION__
Release:	__RELEASE__
Summary:	Command line utility for downloading podcasts
Group:		Applications/Web
License:	GPL >= v2
BuildArch:	noarch
Packager:	Phil Seeley <phil_seeley@hotmail.com>
Requires:		wget, xsltproc

%description
podder reads the list of feeds from one of more configuration
files. Options can be assigned to individual feeds or to whole
configuration files.

%prep

%install

%files
/usr/bin/podder
/usr/share/man/man1/podder.1.gz
/usr/share/doc/podder/Changelog
