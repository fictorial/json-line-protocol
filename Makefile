test:
	@if [ ! -d node_modules/nodeunit ]; then npm i nodeunit; fi
	@nodeunit t/test.coffee

compile:
	coffee -c -o lib src/json-line-protocol.coffee

npm: compile
	npm publish

clean:
	rm -rf lib

.PHONY: compile test npm clean
