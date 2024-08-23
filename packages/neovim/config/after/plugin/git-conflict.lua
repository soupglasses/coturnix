local ok, git_conflict = pcall(require, 'git-conflict')
if not ok then
  return
end

git_conflict.setup {}
