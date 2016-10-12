#!/bin/bash

echo ''
echo 'Installing dependencies in config/ ...'
cd config
pub get
cd ..

echo ''
echo 'Installing dependencies in exec/ ...'
cd exec
pub get
cd ..

echo ''
echo 'Installing dependencies in ops-intrinsics-replacer/ ...'
cd ops-intrinsics-replacer
pub get
cd ..

echo ''
echo 'Installing dependencies in parser/ ...'
cd parser
npm install && echo 'Got dependencies!'
cd ..

echo ''
echo 'Installing dependencies in runner/ ...'
cd runner
pub get
cd ..

echo ''
echo 'Installing dependencies in vis-server/ ...'
cd vis-server
pub get
cd ..

echo ''
echo 'Installing dependencies in vis/ ...'
cd vis
pub get
cd ..

echo ''
echo 'Installing dependencies in web-editor/ ...'
cd web-editor
pub get
cd ..
