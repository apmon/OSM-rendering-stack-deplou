#!/bin/bash
cp -r /usr/local/src/svn/openstreetmap-carto-verbatim src/
rm -rf src/.git

cp -r debian/ src/

cd src
/usr/local/src/svn/carto-npm/node_modules/carto/bin project.mml > osm.xml
debuild -S
cd ..

dput ppa:kakrueger/osm-unstable openstreetmap-mapnik-carto-stylesheet-data_*_source.changes
 

rm openstreetmap-mapnik-carto-stylesheet-data_*_source.changes
rm openstreetmap-mapnik-carto-stylesheet-data_*.dsc
rm -rf src

