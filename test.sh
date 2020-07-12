# Settings
export NIMTEROP=exclude

# Shortcuts
alias ix="curl -F 'f:1=<-' ix.io"
gclone() { git clone "https://github.com/$1" $2 $3 $4 $5 $6 $7 $8 $9; }
gco () { git checkout $1; }

gcloneBranch() {
  gclone $1/$2
  cd $2
  if [[ "$3" != "" ]]; then
    gco $3
  fi
  nimble develop -y
  cd ..
}

test() {
  gcloneBranch $1 $2 $3
  cd $2
  nimble test
  cd ..
}

# OSX setup
if [[ "$TRAVIS_OS_NAME" == "osx" ]]
then
  brew update
  brew install boehmgc
fi

set -e

if [[ "$TRAVIS_OS_NAME" == "osx" ]]
then
  unset -f cd
  shell_session_update() { :; }
fi

rm -rf test
mkdir test
cd test

# Nimterop setup
gcloneBranch nimterop nimterop $NIMTEROP
cd nimterop
nimble buildTimeit
nimble bt
cd ..

test genotrance nimpcre

test genotrance nimarchive

if [[ "$BRANCH" != "0.20.2" ]];
then
  gclone dom96/choosenim
  cd choosenim
  nimble install -d -y  # Cannot nimble develop binary package
  nimble test
  cd ..
fi

test genotrance nimgit2

if [[ "$BRANCH" != "0.20.2" ]];
then
  test disruptek gittyup
fi

test genotrance nimbass