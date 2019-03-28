map(
  select(.type=="visualization")
  | .attributes.kibanaSavedObjectMeta.searchSourceJSON
  |= (
    fromjson
    | .index = $ENV.INDEX_PATTERN_ID
    | tojson
  )
)
