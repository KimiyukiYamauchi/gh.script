#!/bin/bash
# clone.txt にある GitHub リポジトリを順に処理
# 既存ディレクトリがあれば git pull、新規なら git clone

# clone.txt が存在するか確認
if [ ! -f "clone.txt" ]; then
  echo "clone.txt が見つかりません。スクリプトと同じディレクトリに置いてください。"
  exit 1
fi

# クローン先ベースディレクトリ
DEST_BASE="./repos"

# ディレクトリ作成
mkdir -p "$DEST_BASE"

# 各URLを処理
while read -r repo; do
  # 空行スキップ
  if [ -z "$repo" ]; then
    continue
  fi

  # URLから学籍番号 (s24xxx) を抽出
  student_id=$(echo "$repo" | grep -oE 's24[0-9]{3}')
  
  if [ -z "$student_id" ]; then
    echo "⚠️ 学籍番号が抽出できません: $repo"
    continue
  fi

  target_dir="$DEST_BASE/$student_id"

  if [ -d "$target_dir/.git" ]; then
    echo "🔄 既存ディレクトリ検出: $student_id → git pull 実行中..."
    (
      cd "$target_dir" && git pull
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

echo "🎉 すべての処理が完了しました。"
