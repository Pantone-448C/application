# WanderList Application
This is the repository that stores the application code for WanderList, being built out by Pantone 448C.

## Running the application

### Installation
Building and installing this application requires the `flutter` and `adb` command line utilities to be installed. See the installation guides for [flutter](https://flutter.dev/docs/get-started/install) and [adb](https://developer.android.com/studio/command-line/adb) for more information.

Clone the repository
```bash
git clone https://www.github.com/Pantone-448C/application.git && cd application
```
#### Dependencies
Install dependencies & relevant package commands
```bash
flutter pub get && flutter pub run flutter_launcher_icons:main
```

#### IDE (Android)
Using Android Studio, this application can be built by clicking "Run" after opening the project.

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
