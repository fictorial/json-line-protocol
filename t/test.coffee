JsonLineProtocol = (require '../src/json-line-protocol').JsonLineProtocol

unexpected_emit = (test) -> 
  () ->
    console.log 'unexpected_emit event emitted'
    test.ok false
    test.done()

module.exports =
  test_create: (test) ->
    test.expect 1
    test.doesNotThrow -> new JsonLineProtocol
    test.done()

  test_full_one: (test) ->
    test.expect 1
    protocol = new JsonLineProtocol
    protocol.on 'value', (value) -> test.equal value, 'apple'
    protocol.on 'drain', -> test.done()
    protocol.on 'partial', unexpected_emit test
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', unexpected_emit test
    protocol.feed '"apple"\r\n'

  test_partial_one: (test) ->
    test.expect 1
    protocol = new JsonLineProtocol
    protocol.on 'partial', ->
      test.ok true
      test.done()
    protocol.on 'value', unexpected_emit test
    protocol.on 'drain', unexpected_emit test
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', unexpected_emit test
    protocol.feed '"app'

  test_full_two: (test) ->
    expected_values = [ 'apple', 42 ]
    test.expect 3
    protocol = new JsonLineProtocol
    protocol.on 'value', (value) ->
      test.equal value, expected_values.shift()
    protocol.on 'drain', ->
      test.equal expected_values.length, 0
      test.done()
    protocol.on 'partial', unexpected_emit test
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', unexpected_emit test
    protocol.feed '"apple"\r\n42\r\n'

  test_partial_two: (test) ->
    expected_values = [ 'apple' ]
    test.expect 1
    protocol = new JsonLineProtocol
    protocol.on 'value', (value) -> test.equal value, 'apple'
    protocol.on 'partial', -> test.done()
    protocol.on 'drain', unexpected_emit test
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', unexpected_emit test
    protocol.feed '"apple"\r\n42\r' # missing \n

  test_partial_two_deferred: (test) ->
    expected_values = [ 'apple', 42 ]
    test.expect 4
    protocol = new JsonLineProtocol
    protocol.on 'value', (value) ->
      test.equal value, expected_values.shift()
    protocol.on 'partial', ->
      test.equal expected_values.length, 1
      protocol.feed '\n'
    protocol.on 'drain', ->
      test.equal expected_values.length, 0
      test.done()
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', unexpected_emit test
    protocol.feed '"apple"\r\n42\r' # missing \n

  test_overflow: (test) ->
    test.expect 1
    protocol = new JsonLineProtocol 8
    protocol.on 'value', unexpected_emit test
    protocol.on 'partial', unexpected_emit test
    protocol.on 'drain', unexpected_emit test
    protocol.on 'error', unexpected_emit test
    protocol.on 'overflow', ->
      test.ok true
      test.done()
    protocol.feed '"apple"\r\n' # 9 > 8
