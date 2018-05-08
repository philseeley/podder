%define _topdir %(pwd)

Name:		podder
Version:	__VERSION__
Release:	__RELEASE__
Summary:	Command line utility for downloading podcasts
Group:		Applications/Web
License:	GPL >= v2
BuildArch:	noarch
BuildRoot:	%{_builddir}
Packager:	Phil Seeley <phil.seeley@gmail.com>
Requires:	wget, curl, /usr/bin/xsltproc

%description
podder reads the list of feeds from one of more configuration
files. Options can be assigned to individual feeds or to whole
configuration files.

%prep

rm -rf %{buildroot}/*
mkdir -p %{buildroot}

%install

mkdir -p %{buildroot}/usr/share/man/man1 %{buildroot}/usr/bin %{buildroot}/usr/share/doc/podder

mv ../podder.1.gz %{buildroot}/usr/share/man/man1/
mv ../podder      %{buildroot}/usr/bin/
mv ../Changelog   %{buildroot}/usr/share/doc/podder/

%files
/usr/bin/podder
/usr/share/man/man1/podder.1.gz
/usr/share/doc/podder/Changelog
