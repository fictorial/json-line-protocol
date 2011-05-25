EventEmitter = (require 'events').EventEmitter

full_lines_regex = /[^\r]+\r\n/g

class JsonLineProtocol extends EventEmitter
  constructor: (@max_size=0) -> @input = ''

  feed: (input) ->
    if @input.length + input.length > @max_size and @max_size > 0
      @emit 'overflow'
      return
    @input += input
    @_process_input()
    if @input.length is 0
      @emit 'drain'
    else
      @emit 'partial'
    return @input.length

  _process_input: ->
    offset = 0
    lines = (@input.match full_lines_regex) or []
    for line in lines
      offset += line.length
      @_process_line line
    @input = @input.substr offset if offset > 0
    return

  _process_line: (line) ->
    try
      @emit 'value', JSON.parse line = line.trim()
    catch error
      @emit 'error', error, line
    return

exports.JsonLineProtocol = JsonLineProtocol
