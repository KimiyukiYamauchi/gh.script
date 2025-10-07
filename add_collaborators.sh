#!/bin/bash

REPO="KimiyukiYamauchi/memo.react.tl"  # 例: KimiyukiYamauchi/unix1.2025.y
PERMISSION="push"  # pull / push / admin

while IFS= read -r user
do
  echo "Adding $user to $REPO with $PERMISSION permission..."
  res=$(gh api -X PUT "repos/$REPO/collaborators/$user" -f permission=$PERMISSION 2>&1)
  if [[ $? -eq 0 ]]; then
    echo "✅ $user added successfully."
  else
    echo "❌ Failed to add $user: $res"
  fi
done < collaborators.txt

