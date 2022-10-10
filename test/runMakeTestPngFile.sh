#!/bin/zsh

CURRENT_DIR=$(cd $(dirname $0);pwd)
cd $CURRENT_DIR

ruby makeTestPngFile.rb
