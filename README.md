# JsonLineProtocol

A stream protocol handler for JSON-encoded values delimited by CRLF.

## Installation

    npm i json-line-protocol

## Usage

````javascript
var protocol = new(require('json-line-protocol').JsonLineProtocol)();

protocol.on('value', function (value) {
  console.log(util.inspect(value));
});

protocol.feed('{"say":"goodbye","who":"you"}\r\n{"say":"hello","who":"I"}\r\n{"cmd');
// note fragment at the end: {"cmd                                           ^^^^^

// then suddenly, the rest of the command arrives in another chunk!
protocol.feed('":"hey-la hey-hey-lo-la","who":"everybody"}\r\n');
````

## Methods

### new JsonLineProtocol(max_size)

`max_size` is the number of bytes fed input can be allowed to grow to
before emitting an 'overflow' error.

### feed(input)

`input` is a UTF-8 encoded string chunk. `input` does not have to
contain a CRLF suffix; keep feeding the protocol instance as you
receive data from a readable stream.

## Events

### value (parsed_value)

For each full line containing a JSON value is parsed.

### error (error, line)

If a line is not valid JSON.

### drain ()

When all fed input has been processed.

### partial ()

When fed input contains a partial line after processing.

### overflow ()

When fed input + previous partial input is larger than `max_size`.

## Author

Brian Hammond <brian@fictorial.com> (http://fictorial.com)

## License

MIT

