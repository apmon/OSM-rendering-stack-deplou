#!/bin/sh

cp -r /usr/local/src/svn/osm2pgsql-verbatim/ src/
rm -rf src/.git
cp -r debian src
cd src
debuild -S
cd ..

dput ppa:kakrueger/osm-unstable osm2pgsql_*_source.changes

rm osm2pgsql_*_source.*
rm osm2pgsql_*.dsc
rm -rf src
