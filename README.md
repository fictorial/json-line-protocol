# JsonLineProtocol

A stream protocol handler for JSON-encoded values delimited by CRLF.

## Installation

    npm i json-line-protocol

## Development

    npm i json-line-protocol --devel
    make test

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

Copyright (c) 2011 Fictorial LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

