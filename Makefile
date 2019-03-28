.PHONY: default dump restore save clean

URL_KIBANA=http://localhost:5601
#export HTTPS_PROXY=socks5h://localhost:1080

export BACKUP_DIR=backup

.DEFAULT_GOAL := default

default:
	$(warning URL_KIBANA = ${URL_KIBANA})

###--------------------------------------------
# API
###--------------------------------------------
# saved_objects をダンプ
dump:
	@ curl -s ${URL_KIBANA}/api/saved_objects/_find?per_page=1000 \
		| jq '.saved_objects'

# saved_objects を復元
restore:
	$(warning <read "saved_objects.json" from stdin>)
	@ jq 'map({ id: .id, type: .type, attributes: .attributes })' \
		| curl -s -XPOST \
			-H "Content-Type: application/json" \
			-H "kbn-xsrf: reporting" \
			${URL_KIBANA}/api/saved_objects/_bulk_create?overwrite=true \
			-d @-

###--------------------------------------------
# utility
###--------------------------------------------
# Scripted fields を抽出
show-scripted_fields:
	$(warning <read "saved_objects.json" from stdin>)
	@ jq -f jq/show-scripted_fields.jq

# visualization の index_id を書き換える
rewrite-visualization-index_id: export INDEX_PATTERN_ID="ここを書き換える"
rewrite-visualization-index_id:
	$(warning INDEX_PATTERN_ID = ${INDEX_PATTERN_ID})
	$(warning <read "saved_objects.json" from stdin>)
	@ jq -f jq//rewrite-visualization-index_id.jq


###--------------------------------------------
# dump and commit
###--------------------------------------------
${BACKUP_DIR}:
	@ mkdir -p ${BACKUP_DIR}
	@ cd ${BACKUP_DIR} \
		&& git init \
		&& git commit --allow-empty -m "init"

save: ${BACKUP_DIR}
	@ $(MAKE) dump > ${BACKUP_DIR}/saved_objects.json
	@ bash commit.sh

clean:
	@ rm -rf ${BACKUP_DIR}

