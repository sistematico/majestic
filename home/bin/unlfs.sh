#!/usr/bin/env bash
# 
# Un-LFS
#
# Source: https://github.com/git-lfs/git-lfs/issues/3026#issuecomment-451598434
# 

#git lfs untrack '<pattern>'
#git add --renormalize .
#git commit -m 'Restore file contents that were previously in LFS'

git lfs uninstall
git lfs ls-files | sed -r 's/^.{13}//' > /tmp/lfs-files.txt
while read line; do git rm --cached "$line"; done < /tmp/files.txt
while read line; do git add "$line"; done < /tmp/files.txt
git add .gitattributes
git commit -m "unlfs"
#git push origin
git push
rm -rf .git/lfs
