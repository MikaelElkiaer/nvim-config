(call_expression
  function: (identifier) @_id
  (#eq? @_id "inSh")
  arguments: (argument_list
    ; (raw_string_literal) @bash))
    (raw_string_literal) @bash @injection.content
    (#set! injection.language "bash")))
