#!/bin/bash

REPO="KimiyukiYamauchi/prog1.py"  # 例: KimiyukiYamauchi/unix1.2025.y

# コラボレータ一覧を取得し、ログイン名だけ抽出してループ処理
gh api "repos/$REPO/collaborators" \
  --jq '.[].login' |
while read user; do
  echo "Removing collaborator: $user"
  gh api -X DELETE "repos/$REPO/collaborators/$user"
done

