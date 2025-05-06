# 🔥 iCollect App

# Running version

<img src="assets/readme/current_running.png" heigh= "500">

**=> Managing multiple FLutter SDK version [Docs Reference](https://fvm.app)**

## Run app

```bash
  flutter run
```

or

```bash
  sh sh/app_run.sh
```

## Build Android Uat

```bash
  sh sh/build_uat_android.sh
```

## Build Android Prod

```bash
  sh sh/build_prod_android.sh
```

## Select archive IOS

`Product` -> `Archive` -> Build done and then choose provisioning match flavor beforce

<img src="assets/readme/config_ios_12.png">

# VSCode Flavor Configuration

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Athena Owl Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_uat.dart",
      "args": ["--flavor", "uat"]
    },
    {
      "name": "Athena Owl",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod"]
    }
  ]
}
```

# AndroidStudio Flavor Configuration

In-order to flavoring configuration, navigate to `Android Studio` -> `Run/Edit Configurations` -> `Add and Fill info` Like this:
<img src="assets/readme/flavoring_android_studio.png">

# Isolating Your App’s Configuration

Customize some settings for each of those flavors.

```dart
enum EnvironmentType { uat, production }
```

```dart
import 'enviroment_type.dart';

class Environment {
  static Environment value;
  String hostName;
  String appTitle;
  EnvironmentType environmentType = EnvironmentType.uat;
  String hostNameServices;
  String hostNameApi;
  String hostChatApi;

  bool enableLogger = false;

  void start() {}
  Environment() {
    value = this;
  }
}
```

---

**NOTE**

## Replace Uat with Production to reference to Prod Server, if you want.

```dart
import 'config/enviroment/app_url.dart';
import 'config/enviroment/enviroment_type.dart';
import 'config/enviroment/environment.dart';
import 'my_app.dart';

Future<void> main() async => Uat();

/// Call api via sandbox url
class Uat extends Environment {
  Uat() {
    MyApp.run();
  }
  @override
  EnvironmentType get environmentType => EnvironmentType.uat;

  @override
  bool get enableLogger => false;

  @override
  String get hostNameServices => AppUrl.uatHostNameServices;

  @override
  String get hostNameApi => AppUrl.uatHostNameApi;

  @override
  String get hostName => AppUrl.uatHostName;

  @override
  String get hostChatApi => AppUrl.uatHostChatApi;

  @override
  String get appTitle => AppUrl.uatAppTitle;
}
```

Access to properties enviroment

```dart
import 'config/enviroment/environment.dart';

Environment.value.hostNameApi
```

## Preparing for Android App

**Step 1:**
Edit in `android/app/build.gradle` file

Add all common configurations to defaultConfig

```groovy
    defaultConfig {
        applicationId "com.fe.newvymo"
        targetSdkVersion rootProject.ext.targetSdkVersion
        targetSdkVersion 33
        minSdkVersion 21
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
        multiDexEnabled true
        ndk {
            abiFilters 'x86', 'x86_64', 'armeabi', 'armeabi-v7a', 'mips', 'mips64', 'arm64-v8a'
        }

    }
```

Create other config for each EVN(`resValue`, `versionName`, `applicationId`, ...):

```groovy
    flavorDimensions "env"

    productFlavors {
    uat {
        dimension "env"
        versionCode 146
        applicationId "com.fe.newvymo"
        versionName "1.0.79.146"
        resValue "string", "app_name", "Athena Owl UAT"
        resValue "string", "manager_license", "f7d46a7473a13c32fe949c40c010a888b8ed282e14f9dd421035f7728819d63d"
        resValue "string", "api_key", "AIzaSyBga_96obWdpPPjUxHqK_CELfMmOSP809g"
    }
    prod {
        dimension "env"
        applicationId "com.fe.athenahunt"
        versionCode 102142
        versionName "1.0.21.42"
        resValue "string", "app_name", "Athena Owl"
        resValue "string", "manager_license", "feed488aeb8429d470c10d5679d76ac88b8a3ba180301bcb62d36afa86086f50"
        resValue "string", "api_key", "AIzaSyBqTQ4Q4eI6MCWfls_0kF4MNpZjqGooDkU"
        }
    }
```

Example accept to value in Mainifest like this:

```xml
<meta-data android:name="com.transistorsoft.locationmanager.license" android:value="@string/manager_license" />
```

**Step 2:**

Create new `properties files` and `values on gradle` for each ENV like this:

<img src="assets/readme/config_properties.png">

Example properties content:

```properties
storePassword=123456
keyPassword=123456
keyAlias=com.fe.newvymo
storeFile=icollect.jks
```

After Then:

Reference to each `key files` matching with ENV

<img src="assets/readme/reference_keys_file.png">

**Step 3:**

Building References to key files

```groovy
    signingConfigs {
        releaseUat {
            keyAlias keystorePropertiesUat['keyAlias']
            keyPassword keystorePropertiesUat['keyPassword']
            storeFile file(keystorePropertiesUat['storeFile'])
            storePassword keystorePropertiesUat['storePassword']
        }

        releaseProd {
            keyAlias keystorePropertiesProd['keyAlias']
            keyPassword keystorePropertiesProd['keyPassword']
            storeFile file(keystorePropertiesProd['storeFile'])
            storePassword keystorePropertiesProd['storePassword']
        }
    }
```

Reference to AndroidMainifest matching with each Enviroment

```groovy
sourceSets {
     uat{
        manifest.srcFile '/src/uat/AndroidManifest.xml'
        }
        prod{
        manifest.srcFile '/src/prod/AndroidManifest.xml'
        }
    }
```

## Preparing for IOS App

Guidline video references
[![GUI REFER](https://lh3.googleusercontent.com/3zkP2SYe7yYoKKe47bsNe44yTgb4Ukh__rBbwXwgkjNRe4PykGG409ozBxzxkrubV7zHKjfxq6y9ShogWtMBMPyB3jiNps91LoNH8A=s500)](https://www.youtube.com/watch?v=Vhm1Cv2uPko)
**Step 1:**

Xcode created three build configurations for you: Debug, Release and Profile.

We need to add more configs for flavor

<img src="assets/readme/config_ios_1.png">

<img src="assets/readme/config_ios_2.png">

<img src="assets/readme/config_ios_3.png">

<img src="assets/readme/config_ios_4.png">

Edit references all for each EVN

<img src="assets/readme/config_ios_5.png">

**Step 2:**

Create new config folder including Google-Services-Info.plist

<img src="assets/readme/config_ios_6.png">

And then:

Redirect to `Target` -> `Build Pharse` -> Expand Copy bundle Resource -> Try to remove any references current to Google-Services-Info

<img src="assets/readme/config_ios_7.png">

**Step 3:**

Create new a `build pharse` with any name to understanding that copy Google-Services-Info.plist

<img src="assets/readme/config_ios_8.png">

And then copy the script below, It's tring to copy Google-Services-Info content.

```ruby
# Type a script or drag a script file from your workspace to insert its path.
environment="default"

# Regex to extract the scheme name from the Build Configuration
# We have named our Build Configurations as Debug-dev, Debug-prod etc.
# Here, dev and prod are the scheme names. This kind of naming is required by Flutter for flavors to work.
# We are using the $CONFIGURATION variable available in the XCode build environment to extract
# the environment (or flavor)
# For eg.
# If CONFIGURATION="Debug-prod", then environment will get set to "prod".
if [[ $CONFIGURATION =~ -([^-]*)$ ]]; then
environment=${BASH_REMATCH[1]}
fi

echo $environment

# Name and path of the resource we're copying
GOOGLESERVICE_INFO_PLIST=GoogleService-Info.plist
GOOGLESERVICE_INFO_FILE=${PROJECT_DIR}/config/${environment}/${GOOGLESERVICE_INFO_PLIST}

# Make sure GoogleService-Info.plist exists
echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_FILE}"
if [ ! -f $GOOGLESERVICE_INFO_FILE ]
then
echo "No GoogleService-Info.plist found. Please ensure it's in the proper directory."
exit 1
fi

# Get a reference to the destination location for the GoogleService-Info.plist
# This is the default location where Firebase init code expects to find GoogleServices-Info.plist file
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo "Will copy ${GOOGLESERVICE_INFO_PLIST} to final destination: ${PLIST_DESTINATION}"

# Copy over the prod GoogleService-Info.plist for Release builds
cp "${GOOGLESERVICE_INFO_FILE}" "${PLIST_DESTINATION}"


```  

Look like this:
<img src="assets/readme/config_ios_9.png">

**Step 4:**
Finals, adjust Provisioning match with each ENVs

<img src="assets/readme/config_ios_10.png">

<img src="assets/readme/config_ios_11.png">
