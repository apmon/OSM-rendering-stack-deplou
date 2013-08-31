#!/bin/bash

################ mod_tile ##############################
cd /usr/local/src/svn/mod_tile-verbatim
git pull

################ precise ##############################
cd /usr/local/src/svn/OSM-rendering-stack-deplou/launchpad/osm-unstable/precise/mod_tile
cp -r /usr/local/src/svn/mod_tile-verbatim/ src/
rm -rf src/debian
rm -rf src/.git
cp -r debian src
cd src
debuild -S
cd ..

dput ppa:kakrueger/osm-unstable libapache2-mod-tile_*_source.changes

rm libapache2-mod-tile_*_source.*
rm libapache2-mod-tile_*.dsc
rm -rf src


################ quantal ##############################
#cd /usr/local/src/svn/OSM-rendering-stack-deplou/launchpad/osm-unstable/quantal/mod_tile
#cp -r /usr/local/src/svn/mod_tile-verbatim/ src/
#rm -rf src/debian
#rm -rf src/.git
#cp -r debian src
#cd src
#debuild -S
#cd ..

#dput ppa:kakrueger/osm-unstable libapache2-mod-tile_*_source.changes

#rm libapache2-mod-tile_*_source.*
#rm libapache2-mod-tile_*.dsc
#rm -rf src


################ osm2pgsql ##############################
cd /usr/local/src/svn/osm2pgsql-verbatim
git pull

################ precise ##############################
#cd /usr/local/src/svn/OSM-rendering-stack-deplou/launchpad/osm-unstable/precise/osm2pgsql
#cp -r /usr/local/src/svn/osm2pgsql-verbatim/ src/
#rm -rf src/debian
#rm -rf src/.git
#cp -r debian src
#cd src
#debuild -S
#cd ..

#dput ppa:kakrueger/osm-unstable osm2pgsql_*_source.changes

#rm osm2pgsql_*_source.*
#rm osm2pgsql_*.dsc
#rm -rf src


################ quantal ##############################
#cd /usr/local/src/svn/OSM-rendering-stack-deplou/launchpad/osm-unstable/quantal/osm2pgsql
#cp -r /usr/local/src/svn/osm2pgsql-verbatim/ src/
#rm -rf src/debian
#rm -rf src/.git
#cp -r debian src
#cd src
#debuild -S
#cd ..

#dput ppa:kakrueger/osm-unstable osm2pgsql_*_source.changes

#rm osm2pgsql_*_source.*
#rm osm2pgsql_*.dsc
#rm -rf src

