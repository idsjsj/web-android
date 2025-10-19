# Android 에뮬레이터 + Play Store 실행용 Dockerfile
FROM ubuntu:22.04

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    wget unzip openjdk-11-jdk qemu-kvm libvirt-daemon-system \
    libvirt-clients bridge-utils virt-manager \
    git curl && \
    rm -rf /var/lib/apt/lists/*

# Android SDK 설치
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O tools.zip && \
    unzip tools.zip && rm tools.zip && \
    mkdir -p /root/.android && touch /root/.android/repositories.cfg

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# SDK 도구 설치
RUN yes | sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "emulator" \
    "platforms;android-31" "system-images;android-31;google_apis_playstore;arm64-v8a"

# 에뮬레이터 생성
RUN echo "no" | avdmanager create avd -n webemu -k "system-images;android-31;google_apis_playstore;arm64-v8a" --device "pixel"

# 포트 노출 (VNC, WebRTC 등)
EXPOSE 5554 5555 5900 6080

# 시작 스크립트 복사
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["bash", "/start.sh"]
