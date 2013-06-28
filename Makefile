SHELL=/bin/bash
PHANTOMAS=master

setup:
	which bundle > /dev/null || gem install bundler
	bundle install --path vendor/bundle

tests:
	bundle exec rake test

phantomas/install:
	cd lib && wget https://github.com/jmervine/phantomas/archive/$(PHANTOMAS).zip && \
		unzip $(PHANTOMAS).zip && rm $(PHANTOMAS).zip
