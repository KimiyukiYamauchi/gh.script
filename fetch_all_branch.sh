git fetch --all --prune --tags

for rb in $(git for-each-ref --format='%(refname:short)' refs/remotes/origin | grep -v '^origin/HEAD'); do
  lb=${rb#origin/}
  # 既にローカルに同名がなければ作成
  if ! git show-ref --verify --quiet refs/heads/"$lb"; then
    git branch --track "$lb" "$rb"
  fi
done
