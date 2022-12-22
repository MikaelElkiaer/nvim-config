; First attempt at bash injection for command blocks
; (block_scalar
;   (comment) @comment
;   (#match? @comment "#(sh|bash)")
; ) @bash

; Taken from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/yaml/injections.scm
(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "command" "cmd")
  value: (block_node
           (block_scalar) @bash (#offset! @bash 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "command" "cmd")
  value: (block_node
           (block_sequence
             (block_sequence_item
               (block_node
                  (block_scalar) @bash (#offset! @bash 0 1 0 0))))))
