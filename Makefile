SHELL=/bin/bash
PHANTOMAS=master

setup:
	which bundle > /dev/null || gem install bundler
	bundle install --path vendor/bundle

test:
	bundle exec rake test

test/functional:
	bundle exec ./tests/functional/autobench_test.sh
	bundle exec ./tests/functional/autobenchconfig_test.sh

test/all: test test/functional

phantomas/install:
	cd lib && wget https://github.com/jmervine/phantomas/archive/$(PHANTOMAS).zip && \
		unzip $(PHANTOMAS).zip && rm $(PHANTOMAS).zip

build:
	rm *.gem
	gem build autobench.gemspec

push:
	gem push autobench-*.gem
