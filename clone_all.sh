#!/bin/bash
# clone.txt にある GitHub リポジトリを順にクローンするスクリプト
# クローン先フォルダ名は URL 内の「s24xxx」を抽出して使用する

# clone.txt が存在するか確認
if [ ! -f "clone.txt" ]; then
  echo "clone.txt が見つかりません。スクリプトと同じディレクトリに置いてください。"
  exit 1
fi

# クローン先のベースディレクトリ（必要に応じて変更可）
DEST_BASE="./repos"

# ベースディレクトリ作成
mkdir -p "$DEST_BASE"

# 1行ずつ読み込んで処理
while read -r repo; do
  # 空行スキップ
  if [ -z "$repo" ]; then
    continue
  fi

  # URL から学籍番号 (s24xxx) を抽出
  student_id=$(echo "$repo" | grep -oE 's24[0-9]{3}')
  
  # 抽出できなければスキップ
  if [ -z "$student_id" ]; then
    echo "⚠️ 学籍番号が抽出できません: $repo"
    continue
  fi

  target_dir="$DEST_BASE/$student_id"
  echo "🌀 Cloning $repo → $target_dir"
  
  git clone "$repo" "$target_dir"

  if [ $? -ne 0 ]; then
    echo "❌ クローン失敗: $repo"
  else
    echo "✅ クローン完了: $student_id"
  fi
done < clone.txt

echo "🎉 すべてのクローン処理が完了しました。"
