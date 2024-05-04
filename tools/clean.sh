#!/bin/bash

flutter clean

cd ./example
flutter clean
cd $OLDPWD

# get pubs again
./tools/pub.sh

echo '## all done'
