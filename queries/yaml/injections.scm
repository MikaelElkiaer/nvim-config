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

; Inject language `helm` for `$tplYaml` blocks
(block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "$tplYaml")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "helm")))

(block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "$tplYaml")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "helm")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "$tplYaml")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "helm")))))

(block_mapping_pair
  key: (flow_node) @_key
  (#eq? @_key "$tplYaml")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "helm")
          (#offset! @injection.content 0 1 0 0))))))
