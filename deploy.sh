#!/bin/bash
set -e
IFS="
"
TMP=/tmp/tldiff
rm -rf "$TMP"
mkdir "$TMP"
cp diff.js atom.xml diffs.js diff.html diff.css "$TMP"
git branch -D gh-pages
git checkout --orphan gh-pages
mv "$TMP"/* .
ls
git config --global user.email "johnprestonmail@gmail.com"
git config --global user.name "GitHub Action <John Preston>"
git add diff.js atom.xml diffs.js diff.html diff.css -f
# the below lines were copied from
# https://github.com/LonamiWebs/Telethon/blob/master/update-docs.sh
git commit -am "TLDiffer: Deploy new layer"
curpath=$(pwd)
git clone https://github.com/LonamiWebs/Telethon /tmp/docgen/
cd /tmp/docgen/
rm telethon_generator/data/api.tl
cimmot="446a06ba461d82aa06aeab23bf92524095b3dd76"
# cimmot="main"
wget "https://github.com/SpEcHiDe/telegram-bot-api-spec/raw/${cimmot}/mtproto.tl" -O telethon_generator/data/api.tl
python setup.py gen docs
rm -rf /tmp/docs
mv docs/ /tmp/docs
cd ${curpath}
mkdir -p docs
cd docs
rm -rf $(ls /tmp/docs)
mv /tmp/docs/* .
git config --global user.email "totufals@hotmail.com"
git config --global user.name "GitHub Action <Lonami Exo>"
git add constructors/ types/ methods/ index.html js/search.js css/ img/
git commit --amend -m "DocGen: Update documentation"
git push --force -u origin gh-pages
git checkout master
