#!/bin/bash

cd ${BACKUP_DIR}

git add *
git diff --cached --exit-code --quiet
ret=$?

if [ $ret -eq 0 ] ;then
    echo "no need to commit."
    exit 0
fi

git commit -m $(date +"%Y-%m-%dT%H:%M:%S.%6N%z")

