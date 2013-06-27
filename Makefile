SHELL=/bin/bash

setup:
	which bundle > /dev/null || gem install bundler
	bundle install --path vendor/bundle

test:
	bundle exec rake test

upgrade/loadreport:
	cd lib && rm loadreport.js && wget "https://raw.github.com/wesleyhales/loadreport/master/loadreport.js"

