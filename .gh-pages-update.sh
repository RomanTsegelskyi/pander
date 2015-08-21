#!/bin/bash
GH_REPO="@github.com/Rapporter/pander.git"
FULL_REPO="https://$GH_TOKEN$GH_REPO"

mkdir out
cd out
git init
git remote add origin $FULL_REPO
git fetch
git config user.name "rapporter-travis"
git config user.email "travis"

# handle master
git checkout master
CHANGED_FILES=`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`
# check if vignettes were updated
R -e 'devtools::build_vignettes()'
git add inst\doc
# check if readme was update
R -f ../.brewer.R
git add README.md
git commit -m "Update by travis after $TRAVIS_COMMIT"
git push origin master
git stash

# gh-pages handling
git checkout gh-pages
for files in '../inst/doc/*.html'; do
        cp $files .
done

R -f ../.brewer.R

git add .
git commit -m "GH-Pages update by travis after $TRAVIS_COMMIT"
git push origin gh-pages
