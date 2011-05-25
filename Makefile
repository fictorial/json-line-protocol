compile:
	coffee -c -o lib src/json-line-protocol.coffee

test:
	nodeunit t/test.coffee

npm: compile
	npm publish

clean:
	rm -rf lib

.PHONY: compile test npm clean
