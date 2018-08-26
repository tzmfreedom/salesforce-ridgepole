.PHONY: rubocop
rubocop:
	bundle exec rubocop -a

.PHONY: test
test:
	bundle exec rspec

.PHONY: build
build:
	docker build -t tzmfreedom/salesforce-ridgepole .

