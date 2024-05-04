#!/bin/bash

flutter pub outdated --no-transitive

cd ./example
flutter pub outdated --no-transitive
cd $OLDPWD

echo '### all done'
