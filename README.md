# kibana の saved_objects を操作

## usage

### バックアップを取る

```
make save
```

[backup/saved_objects.json](./backup/saved_objects.json) に保存します。

### 復元

```
make restore < backup/saved_objects.json
```

### visualization の INDEX_PATTERN_ID を書き換える

`visualization` はインデックスパターンに紐付いているので、そのままだと他のkibanaで復元できないため。

cf. https://qiita.com/NAO_MK2/items/2d03d9db1cd7b0ceae04

```
make rewrite-visualization-index_id INDEX_PATTERN_ID=hoge < backup/saved_objects.json
```
