#!/bin/sh
VERSION=0.1.0

rm *.gem *.tar.bz2
rm -rf doc
rdoc  -w 4 -SHN -m README README --title 'activerecord-alt-mongo-adapter is a MongoDB adapter for ActiveRecord.'
tar jcvf activerecord-alt-mongo-adapter-${VERSION}.tar.bz2 --exclude=.svn lib README *.gemspec doc
gem build activerecord-alt-mongo-adapter.gemspec
