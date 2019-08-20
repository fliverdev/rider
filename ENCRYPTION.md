# Encryption

This project contains certain files that are encrypted using [git-crypt](https://github.com/AGWA/git-crypt) due to the use of API keys to connect to Firebase and Google Maps, which is why it will not build directly on your machine.

The following are the files that have been encrypted:

-   `/android/app/src/main/AndroidManifest.xml`
-   `/ios/Runner/AppDelegate.swift`
-   `/android/app/google-services.json`
-   `/ios/Runner/GoogleService-Info.plist`

In order to resolve this, you must replace the encrypted files with files containing your own API credentials. These API credentials can be obtained by [creating a new Firebase project](https://console.firebase.google.com/) and following the instructions from there.

### Android Manifest

Replace the encrypted `AndroidManifest.xml` with the following contents:

    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        package="dev.fliver.rider">
        <application
            android:name="io.flutter.app.FlutterApplication"
            android:label="Fliver Rider"
            android:icon="@mipmap/ic_launcher"
            tools:ignore="GoogleAppIndexingWarning">
            <activity
                android:name=".MainActivity"
                android:launchMode="singleTop"
                android:theme="@style/LaunchTheme"
                android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
                android:hardwareAccelerated="true"
                android:windowSoftInputMode="adjustResize">
                <meta-data
                    android:name="io.flutter.app.android.SplashScreenUntilFirstFrame"
                    android:value="true" />
                <intent-filter>
                    <action android:name="android.intent.action.MAIN"/>
                    <category android:name="android.intent.category.LAUNCHER"/>
                </intent-filter>
            </activity>
            <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY"/>
        </application>
        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
    </manifest>

### iOS App Delegate

Replace the encrypted `AppDelegate.swift` with the following contents:

    import UIKit
    import Flutter
    import Firebase
    import GoogleMaps

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
        override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
            ) -> Bool {
            GeneratedPluginRegistrant.register(with: self)
            FirebaseApp.configure()
            GMSServices.provideAPIKey("YOUR_API_KEY")
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }

### Google Services for Firebase

The `google-services.json` and `GoogleService-Info.plist` can be downloaded from your Firebase project for Android and iOS respectively. Replace the new files with the older, encrypted ones.
