#mozilla-firefox
#exit
export MOZILLA_HOME=$HOME/mozilla/firefox
#export MOZILLA_HOME=/usr/local/mozilla-firefox
export LD_LIBRARY_PATH=$MOZILLA_HOME:$HOME/mozilla/plugins
export PATH=$PATH:$MOZILLA_HOME
cd $MOZILLA_HOME
./firefox
