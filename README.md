# recipes

Buildbot recipes (tested with buildbot and buildbot-slave 0.8.9)
REPOS=https://github.com/buildbot-cookbook

# Set up root directory
mkdir buildbot-cookbook
cd buildbot-cookbook
source recipes/utils.sh
ROOT=$PWD
hook="$ROOT/recipes/post-receive"

# Get recipes
cd $ROOT
git clone $REPOS/recipes

# Fork some repos to push in and to be tested in buildbot
git clone --bare $REPOS/libgreet
git clone --bare $REPOS/hello

# Install hooks to trigger buildbot
install_hook $hook hello libgreet
install_hook $hook hello hello

# Clone repos so we can commit in it
git clone libgreet.git
git clone hello.git

# Set up master
cd $ROOT
buildbot create-master master
cp $ROOT/recipes/simple/master.cfg master/
buildbot start master

# Set up slave
cd $ROOT
buildslave create-slave slave localhost:9989 example-slave pass
buildslave start slave

# web interface
visit: http://localhost:8010

# For other recipes, copy master.cfg, and reconfig master
cd $ROOT
cp recipes/RECIPE_DIR/master.cfg master/
buildbot reconfig master

# Cleaning (remove everything)
cd $ROOT
buildbot stop master
buildslave stop slave
rm -rf hello hello.git libgreet libgreet.git master slave
