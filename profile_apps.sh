PROFILE_DURATION=$((5*60)) # in seconds per app
SLEEP_TIME=3 # sleep in between inputs
ITERATION_DURATION=$(($SLEEP_TIME * 3))

# intent names
declare -A apps
apps["edge"]="com.microsoft.emmx/com.microsoft.ruby.Main"
apps["firefox"]="org.mozilla.firefox/org.mozilla.firefox.App"
apps["earth"]="com.google.earth/com.google.android.apps.earth.flutter.EarthFlutterActivity"
apps["maps"]="com.google.android.apps.maps/com.google.android.maps.MapsActivity"
apps["tiktok"]="com.zhiliaoapp.musically/com.ss.android.ugc.aweme.main.MainActivity"
apps["x"]="com.twitter.android/com.twitter.android.StartActivity"
apps["youtube"]="com.google.android.youtube/.HomeActivity"
#apps+=("com.bushiroad.en.bangdreamgbp/com.google.firebase.MessagingUnityPlayerActivity")

echo "log plugin" | socat - unix-connect:/home/yaene/cuttlefish/cuttlefish/instances/cvd-1/qemu-monitor-socket

for app in "${!apps[@]}"; do
  adb shell am start -W -n ${apps[$app]}
  sleep 20

  echo "logfile ${app}.log" | socat - unix-connect:/home/yaene/cuttlefish/cuttlefish/instances/cvd-1/qemu-monitor-socket
  for i in $(seq 0 $ITERATION_DURATION $PROFILE_DURATION); do
    adb shell input swipe 340 865 370 202; sleep $SLEEP_TIME
    adb shell input swipe 400 200 400 800; sleep $SLEEP_TIME
    adb shell input tap 100 2200; sleep $SLEEP_TIME
  done
  echo "logfile none.log" | socat - unix-connect:/home/yaene/cuttlefish/cuttlefish/instances/cvd-1/qemu-monitor-socket
  adb shell am force-stop $(adb shell dumpsys window | grep -E 'mCurrentFocus' | awk -F '/' '{print $1}' | awk '{print $NF}')
  sleep 20
done
