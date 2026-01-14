; Inject language for multiline blocks using block comment
; - Usage: `<key>: | # @ts=<language>\n`
(block_node
  (block_scalar
    (comment) @injection.language) @injection.content
    ; Extract language string
    (#gsub! @injection.language "^#%s*@ts=([%w_]+).*$" "%1")
    ; Skip if no match
    (#not-eq? @injection.language "")
    ; Skip initial `|` as this should not be part of the block
    ; - would cause stack overflow when injection language is "yaml"
    (#offset! @injection.content 0 1 0 0))

; Inject language based on key file extension
(block_mapping_pair
  key: (flow_node) @injection.language
  ; Extract language string
  ; TODO: Handle more than 1 dot
  ; - figure out why `[^.]` cannot be replaced by `.`
  (#gsub! @injection.language "^[^.]*\.([^.]+)$" "%1")
  ; Skip if no match
  (#not-eq? @injection.language "")
  value: [
    (block_node
      (block_scalar) @injection.content
      ; TODO: Figure out why offset only works for |- and >-
      ; - and no longer seems to be needed at all
      (#offset! @injection.content 0 0 0 0))
    (flow_node
      (plain_scalar
        (string_scalar) @injection.content))
    (block_node
      (block_sequence
        (block_sequence_item
          (flow_node
            (plain_scalar
              (string_scalar) @injection.content)))))
    (block_node
      (block_sequence
        (block_sequence_item
          (block_node
            (block_scalar) @injection.content
            (#offset! @injection.content 0 1 0 0)))))
  ])

; Inject language `helm` for `$tplYaml` blocks
(block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "$tplYaml")
  value: [
    (flow_node
      (plain_scalar
        (string_scalar) @injection.content)
      (#set! injection.language "helm"))
    (block_node
      (block_scalar) @injection.content
      (#set! injection.language "helm")
      (#offset! @injection.content 0 1 0 0))
    (block_node
      (block_sequence
        (block_sequence_item
          (flow_node
            (plain_scalar
              (string_scalar) @injection.content))
          (#set! injection.language "helm"))))
    (block_node
      (block_sequence
        (block_sequence_item
          (block_node
            (block_scalar) @injection.content
            (#set! injection.language "helm")
            (#offset! @injection.content 0 1 0 0)))))
  ])

; Inject language `bash` for known CI files
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: [
    (flow_node
      (plain_scalar
        (string_scalar) @injection.content)
      (#set! injection.language "bash"))
    (block_node
      (block_scalar) @injection.content
      (#set! injection.language "bash")
      (#offset! @injection.content 0 1 0 0))
    (block_node
      (block_sequence
        (block_sequence_item
          (flow_node
            (plain_scalar
              (string_scalar) @injection.content))
          (#set! injection.language "bash"))))
    (block_node
      (block_sequence
        (block_sequence_item
          (block_node
            (block_scalar) @injection.content
            (#set! injection.language "bash")
            (#offset! @injection.content 0 1 0 0)))))
  ])

; Inject language `promql` in any `expr` block
; TODO: Limit by ensuring parent sequence `rules`
((block_mapping_pair
    key: (flow_node) @key_name
    value: (block_node (block_scalar) @injection.content))
  (#match? @key_name "^expr$")
  (#set! injection.language "promql"))
