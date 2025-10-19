#!/bin/bash
echo "✅ Android Emulator starting..."

# 가상 디스플레이 준비
Xvfb :0 -screen 0 1280x720x16 &
export DISPLAY=:0

# 에뮬레이터 실행
$ANDROID_HOME/emulator/emulator -avd webemu -no-snapshot -gpu swiftshader_indirect -noaudio -no-boot-anim -port 5554 &

# VNC 또는 웹 리모트 접속기 준비 (선택)
apt-get update && apt-get install -y novnc websockify
websockify --web /usr/share/novnc/ 6080 localhost:5900
