;; extends

; rust-analyzer adds no semantic tokens inside macro_rules! definitions, and the default queries
; capture `macro_rules!`, metavariables and attribute names all as macros. Give each its own role,
; so a macro reads like a function: keyword, name, parameters and their kinds
(macro_definition
  "macro_rules!" @keyword.function)

(macro_definition
  name: (identifier) @function.macro)

(metavariable) @variable.parameter

(fragment_specifier) @type.builtin

(token_repetition_pattern
  [
    "$"
    "*"
    "+"
    "?"
  ] @punctuation.special)

(token_repetition
  [
    "$"
    "*"
    "+"
    "?"
  ] @punctuation.special)

; Macro calls inside macro bodies, where they're only loose tokens
(token_tree
  (identifier) @function.macro
  .
  "!")

; Attributes aren't macros
(attribute_item
  (attribute
    (identifier) @attribute))

(inner_attribute_item
  (attribute
    (identifier) @attribute))
