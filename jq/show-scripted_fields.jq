[
  .[]
  | select(.type=="index-pattern")
  | { key: .attributes.title,
      value: [
        .attributes.fields
        | fromjson
        | .[] | select(.scripted)
        | { name: .name, script: .script }
      ]
    }
]
| from_entries
