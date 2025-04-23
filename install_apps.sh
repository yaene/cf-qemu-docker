#!/bin/bash

# connect to adb server
adb connect localhost:6520

# install all test apps
for app in apks/*; do
  adb install-multiple -g $(find $app -name "*.apk")
done

# unlock phone
adb shell input keyevent 66


