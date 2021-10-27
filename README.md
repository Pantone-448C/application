# WanderList Application
This is the repository that stores the application code for WanderList, being built out by Pantone 448C.

## Running the application

### Installation
Note that this requires the `flutter` and `adb` command line utilities to be installed. See the installation guides for [flutter](https://flutter.dev/docs/get-started/install) and [adb](https://developer.android.com/studio/command-line/adb)


```bash
git clone https://www.github.com/Pantone-448C/application.git && cd application
```
#### Dependencies
Install dependencies & relevant package commands
```bash
flutter pub get && flutter pub run flutter_launcher_icons:main
```

#### IDE (Android)
The easiest way to now get this running is through an IDE like Android Studio or VSCode (with plugins).

#### CLI (Android)
Using CLI, the application can be built and installed onto a device using
```bash
flutter run
```

If you want to run on a specific device (when multiple are connected), specify the device using
```bash
flutter run -d [device-name]
```

Device name can be found using
```bash
adb devices
```
