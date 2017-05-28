# recipes
Buildbot recipes (tested with buildbot and buildbot-slave 0.8.9)
REPOS=https://github.com/buildbot-cookbook

# Set up root directory
mkdir buildbot-cookbook
cd buildbot-cookbook
ROOT=$PWD

# Get recipes
cd $ROOT
git clone $REPOS/recipes

# Fork some repos to push in and to be tested in buildbot
git clone --bare $REPOS/greet

# Install hooks to trigger buildbot
cp $ROOT/recipes/post-receive greet.git/hooks

# Clone repos so we can commit in it
git clone greet.git

# Set up master
cd $ROOT
buildbot create-master master
cp $ROOT/recipes/simple/master.cfg master/
buildbot start master

# Set up slave
buildslave create-slave slave localhost:9989 example-slave pass
buildslave start slave

# web interface
visit: http://localhost:8010
