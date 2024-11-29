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
