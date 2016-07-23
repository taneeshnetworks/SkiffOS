#!/bin/bash

if [ ! -f .quiet-patched ]; then
  echo "Applying patch to messages..."
  git apply ../../resources/patches/quiet-log-messages.patch
  touch .quiet-patched
fi

echo "Starting buildroot quietly..."
if [ -f ./buildroot-messages.log ]; then
  rm ./buildroot-messages.log
fi
touch buildroot-messages.log
tail -f ./buildroot-messages.log &
TAILPID=$?
if ! make >buildroot.log 2>&1 ; then
  kill $TAILPID
  echo "!!! Error in buildroot, showing last 300 lines. !!!"
  tail -n300 ./buildroot.log
  exit 1
fi
kill $TAILPID
