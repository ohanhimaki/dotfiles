; Inject TSX/JSX into script tags with type="text/babel"
((script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value (attribute_value) @_type)))
  (raw_text) @injection.content)
 (#eq? @_attr "type")
 (#eq? @_type "text/babel")
 (#set! injection.language "tsx"))


