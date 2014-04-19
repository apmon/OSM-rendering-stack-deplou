#!/bin/sh

cp -r /usr/local/src/svn/mod_tile-verbatim/ src/
rm -rf src/.git
rm -rf src/debian
cp -r debian src
cd src
debuild -S
cd ..

dput ppa:kakrueger/osm-unstable libapache2-mod-tile_*_source.changes

rm libapache2-mod-tile_*_source.*
rm libapache2-mod-tile_*.dsc
rm -rf src
