# DayCount — Platform Setup Guide

---

## 1. Flutter 프로젝트 기본 설정

### pubspec.yaml 주요 패키지

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.0

  # Local DB
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  path: ^1.9.0

  # Notifications
  flutter_local_notifications: ^17.2.0

  # In-App Purchase
  purchases_flutter: ^8.1.0

  # Firebase
  firebase_core: ^3.6.0
  firebase_analytics: ^11.3.0
  firebase_crashlytics: ^4.1.0

  # UI & Utils
  intl: ^0.19.0
  share_plus: ^10.0.0
  emoji_picker_flutter: ^3.0.0
  google_fonts: ^6.2.0
  confetti_widget: ^0.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  flutter_launcher_icons: ^0.14.0
  flutter_native_splash: ^2.4.0

flutter:
  generate: true  # 다국어 코드 생성

  assets:
    - assets/
    - assets/fonts/
```

### l10n.yaml

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Minimum SDK Versions

| 플랫폼 | 최소 버전 |
|--------|----------|
| Android | minSdkVersion 21 (Android 5.0) |
| iOS | 12.0 |
| Dart SDK | >=3.0.0 |

---

## 2. Android 설정

### android/app/build.gradle

```groovy
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.daycount.app"  // 실제 패키지명으로 변경
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 알림 설정 — AndroidManifest.xml

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <!-- 알림 권한 (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <!-- 정확한 알림 스케줄링 -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <!-- 부팅 후 알림 복원 -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

    <application>
        <!-- 알림 채널은 코드에서 생성 -->

        <!-- 부팅 후 알림 복원 리시버 -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
    </application>
</manifest>
```

### 알림 채널 (코드에서 생성)

```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'daycount_milestones',        // id
  'Milestone Alerts',           // name
  description: 'Notifications for D-Day milestones',
  importance: Importance.high,
);
```

### ProGuard (난독화)

RevenueCat, Firebase 사용 시 proguard-rules.pro 설정 필요:

```
# RevenueCat
-keep class com.revenuecat.purchases.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
```

---

## 3. iOS 설정

### ios/Runner/Info.plist

```xml
<!-- 알림 권한 설명 -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<!-- 갤러리 저장 권한 (공유 카드 저장 시) -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save share cards to your photo library</string>
```

### iOS Deployment Target

Podfile:
```ruby
platform :ios, '12.0'
```

### 알림 권한 요청 (iOS)

iOS는 앱 실행 후 명시적으로 권한 요청 필요:

```dart
final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

// iOS 권한 요청
await plugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(alert: true, badge: true, sound: true);
```

요청 타이밍: 첫 D-Day 생성 시 (온보딩 직후가 아닌, 실제 필요한 시점)

---

## 4. Firebase 설정

### 4.1 Firebase 프로젝트 생성 (수동)

1. https://console.firebase.google.com 접속
2. 프로젝트 생성: "daycount"
3. Analytics 활성화

### 4.2 Android 앱 등록

1. Firebase Console → 앱 추가 → Android
2. 패키지명: `com.daycount.app`
3. `google-services.json` 다운로드
4. 배치: `android/app/google-services.json`

### 4.3 iOS 앱 등록

1. Firebase Console → 앱 추가 → iOS
2. Bundle ID: `com.daycount.app`
3. `GoogleService-Info.plist` 다운로드
4. 배치: `ios/Runner/GoogleService-Info.plist` (Xcode에서 추가)

### 4.4 Gradle 설정

```groovy
// android/build.gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

// android/app/build.gradle
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'
```

### 4.5 코드 초기화

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: DayCountApp()));
}
```

---

## 5. RevenueCat 설정

### 5.1 RevenueCat 계정 생성 (수동)

1. https://app.revenuecat.com 회원가입
2. 프로젝트 생성: "DayCount"

### 5.2 Apple App Store Connect 연동

1. App Store Connect에서 Shared Secret 발급
2. RevenueCat → Apple App Store 설정에 입력
3. 인앱결제 상품 생성:
   - Product ID: `daycount_pro`
   - Type: Non-Consumable
   - Price: $3.99

### 5.3 Google Play Console 연동

1. Google Play Console → 수익화 → 인앱 상품
2. Product ID: `daycount_pro`
3. RevenueCat → Google Play Store 설정에 서비스 계정 JSON 입력

### 5.4 RevenueCat 대시보드 설정

1. Products → 상품 추가: `daycount_pro`
2. Entitlements → 생성: `pro`
   - 연결 상품: `daycount_pro`
3. Offerings → 생성: `default`
   - 패키지 추가: `pro` (Lifetime)
   - 연결 상품: `daycount_pro`

### 5.5 API 키

```dart
// 코드 초기화
await Purchases.configure(
  PurchasesConfiguration("YOUR_REVENUECAT_API_KEY"),  // 플랫폼별
);
```

- iOS API Key: RevenueCat 대시보드 → API Keys → iOS
- Android API Key: RevenueCat 대시보드 → API Keys → Android

**API 키는 코드에 하드코딩하지 않고 환경 변수 또는 dart-define으로 관리 권장.**

### 5.6 Sandbox 테스트

**Apple:**
1. App Store Connect → Users & Access → Sandbox Testers
2. 테스트 계정 생성
3. 기기에서 설정 → App Store → Sandbox Account 로그인
4. 앱에서 구매 → Sandbox 결제 (실제 과금 없음)

**Google:**
1. Google Play Console → 테스트 → 라이선스 테스트
2. 구글 계정 추가 (테스트 계정)
3. 테스트 트랙에 APK 업로드 후 테스트

---

## 6. 이미지 저장 권한 (공유 카드)

### Android

Android 10+ (API 29+)에서는 `MediaStore` API 사용 시 권한 불필요.
Android 9 이하에서는 `WRITE_EXTERNAL_STORAGE` 필요.

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
```

### iOS

`NSPhotoLibraryAddUsageDescription` (Info.plist에 이미 설정)

### 코드에서 저장

```dart
// image_gallery_saver 패키지 또는 직접 구현
// share_plus로 공유 시에는 임시 파일 생성 후 공유 → 저장 권한 불필요
```

**추천:** 갤러리 "저장"은 `path_provider`로 임시 파일 생성 → `share_plus`로 공유 시트 → 유저가 직접 저장. 이렇게 하면 저장 권한 요청 없이 구현 가능.

---

## 7. 앱 서명

### Android

```bash
# keystore 생성 (최초 1회)
keytool -genkey -v -keystore ~/daycount-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias daycount
```

`android/key.properties`:
```
storePassword=<password>
keyPassword=<password>
keyAlias=daycount
storeFile=<path>/daycount-keystore.jks
```

### iOS

Xcode → Signing & Capabilities → Automatically manage signing → Team 선택

---

## 8. 빌드 & 실행 명령어

```bash
# 개발 실행
flutter run

# 분석
flutter analyze

# 테스트
flutter test

# 빌드 (릴리즈)
flutter build apk --release          # Android APK
flutter build appbundle --release     # Android AAB (Play Store 업로드용)
flutter build ios --release           # iOS

# 다국어 코드 생성
flutter gen-l10n
```
