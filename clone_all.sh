#!/bin/bash
# clone.txt の各URLを処理
# 既存なら「git restore --worktree .」→「git pull」、なければ clone

# clone.txt があるか確認
if [ ! -f "clone.txt" ]; then
  echo "clone.txt が見つかりません。スクリプトと同じディレクトリに置いてください。"
  exit 1
fi

# クローン先のベースディレクトリ
DEST_BASE="./repos"
mkdir -p "$DEST_BASE"

while read -r repo; do
  # 空行はスキップ
  [ -z "$repo" ] && continue

  # URLから学籍番号 (s24xxx) を抽出
  student_id=$(echo "$repo" | grep -oE 's24[0-9]{3}')
  if [ -z "$student_id" ]; then
    echo "⚠️ 学籍番号(s24xxx)を抽出できません: $repo"
    continue
  fi

  target_dir="$DEST_BASE/$student_id"

  if [ -d "$target_dir/.git" ]; then
    echo "🔄 既存リポジトリ更新: $student_id"
    (
      cd "$target_dir" || exit 1
      # 作業ツリーの変更を破棄してから最新取得
      git restore --worktree . || exit 1
      git pull || exit 1
    )
    if [ $? -eq 0 ]; then
      echo "✅ 更新完了: $student_id"
    else
      echo "❌ 更新失敗: $student_id"
    fi
  else
    echo "🌀 新規クローン: $repo → $target_dir"
    git clone "$repo" "$target_dir"
    if [ $? -eq 0 ]; then
      echo "✅ クローン完了: $student_id"
    else
      echo "❌ クローン失敗: $student_id"
    fi
  fi
done < clone.txt

echo "🎉 全処理が完了しました。"
