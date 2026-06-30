# 🔐 Firebase Auth Setup Guide

If you see `[ CONFIGURATION_NOT_FOUND ]` on `signUp`, follow these steps in the Firebase Console.

## Step 1: Enable Email/Password provider

1. Open https://console.firebase.google.com → click `flixify-3dca1`
2. Left sidebar → **Authentication** → **Sign-in method** (tab)
3. **Email/Password** row → click the row → toggle **Enable** to ON → Save
4. Confirm it now shows "Enabled" in green

## Step 2: Add your Android debug SHA fingerprints

Run this in the Flutter project root to print them:

```bash
cd android
keytool -list -v -keystore ~/.android/debug.keystore -storepass android \
  -alias androiddebugkey 2>/dev/null | grep -E "SHA1|SHA256"
```

You should see something like:

```
SHA1:   C6:77:C0:06:B1:2C:58:3F:20:BA:55:9F:34:54:A3:63:CB:31:E8:5B
SHA256: C8:E3:50:FD:26:D2:05:8D:33:95:A0:F0:4F:BC:AE:D5:15:4E:48:FF:CB:27:D0:7C:8E:13:56:F4:4C:E9:DF:95
```

Then in the Firebase Console:

1. Project Settings (gear icon) → **General** tab → scroll to "Your apps"
2. Under the Android app (`com.example.my_app`), click **Add fingerprint**
3. Paste **both** SHA-1 and SHA-256
4. **Save** → wait ~1 minute for it to propagate

## Step 3: Disable reCAPTCHA Enterprise (often a culprit)

If step 1 + 2 still show `CONFIGURATION_NOT_FOUND`, the culprit is **reCAPTCHA Enterprise**.

1. Firebase Console → **Authentication** → **Settings** tab
2. **"Email enumeration protection"** section → toggle **OFF**
3. (Optional but safer) **"Authentication email enumeration (protection)"** → also OFF
4. Save

## Step 4: Verify your package name matches

In `android/app/build.gradle.kts`, find:

```kotlin
android {
    namespace = "com.example.my_app"
    ...
    defaultConfig {
        applicationId = "com.example.my_app"
    }
}
```

Both must be the **same string** as the Android app registered in Firebase Console.

## Step 5: Re-test

```bash
flutter clean
flutter pub get
flutter run
```

Then tap **Create account** → enter any email + 6-char password → should succeed instead of `CONFIGURATION_NOT_FOUND`.

---

## If it STILL fails

Take a screenshot of:

1. **Firebase Console → Authentication → Sign-in method** (showing Email/Password is enabled)
2. **Firebase Console → Project Settings → Your apps → SHA certificate fingerprints** (showing your SHA-1)
3. The full red error text from the console debug log

…and paste it back to me. The most likely culprit is the reCAPTCHA step.
