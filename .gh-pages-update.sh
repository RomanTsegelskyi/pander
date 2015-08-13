#!/bin/bash

rm -rf out || exit 0;
rm -rf master.zip
rm -rf pander
rm -rf pander-master
mkdir out;

GH_REPO="@github.com/RomanTsegelskyi/pander.git"
GH_TOKEN="f78038b5c22dd8df5bdaf8934ca18ad2e4eac073"
FULL_REPO="https://$GH_TOKEN$GH_REPO"

for files in '*.tar.gz'; do
       tar xfz $files
done

mv pander-master pander
cp .brewer.R out/.brewer.R
cd out
git init
git remote add origin https://github.com/RomanTsegelskyi/pander.git
git remote -v
git fetch
git checkout gh-pages
git config user.name "rapporter-travis"
git config user.email "travis"

# something to brew everything
# check difference and commit
for files in '../pander/inst/doc/*.html'; do
        cp $files .
done

R -f .brewer.R

cd out

git add .
git commit -m "GH-Pages update by travis"
