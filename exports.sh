#!/bin/bash

export JFROG_HOME=/srv/containers/artifactoryServer/

### Configure the ANDROID_HOME environment variable
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

#########################################################################
############# riscv-gnu-toolchain #######################################
export PATH=$PATH:/home/rawad/source/riscv-gnu-toolchain
#########################################################################
export PATH=$PATH:/home/rawad/bin