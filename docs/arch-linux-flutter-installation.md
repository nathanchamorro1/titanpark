# Arch Linux Flutter Installation Guide

* Using [paru](https://github.com/Morganamilo/paru) package manager.

## Install packages

```bash
paru -S curl git unzip xz zip glu mesa-utils
```

Before installing Android Studio

```bash
paru -S glibc gcc-libs lib32-zlib bzip2
```

## Install Android Studio IDE

```bash
paru -S android-studio
```

Then open Android Studio and install required packages when prompted in the app.

## Install Visual Studio Code Flutter extension

Install this [extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) in Visual Stuido Code.

## Install [Flutter SDK](https://docs.flutter.dev/get-started/install/linux/android#use-vs-code-to-install-flutter) in Visual Studio Code

```bash
CTRL + SHIFT + P # Open Command Palette
flutter # Type flutter to search for flutter
Flutter: New Project # Select this option
Download SDK # Click this when prompted to select Flutter SDK
Esc # Ignore flutter template
```

## Install Android components in Android Studio

1. Open "SDK Manager" to view installed components
2. Click "SDK Tools" tab
3. Make sure the following tools are selected:
```
Android SDK Command-line Tools
Android SDK Build-Tools
Android SDK Platform-Tools
Android Emulator
```

## Accept Android licenses

* First locate ```flutter/bin/``` location where you installed the Flutter SDK
* Add the ```bin``` directory to your PATH in ```.bashrc``` or ```.zshrc```

```bash
# Add this line to your .zshrc file
export PATH="${PATH}:/path/to/flutter/bin/directory"
```

* Source your ```.bashrc``` or ```.zshrc``` file to update PATH

```bash
source ~/.zshrc
```

* Run the following to accept licneses

```bash
flutter doctor --android-licenses 
```

## Set CHROME_EXECUTABLE to Chrome binary

Install Google Chrome if not installed

```bash
paru -S google-chrome
```

Add the following to ```.bashrc``` or ```.zshrc```

```bash
# Set chrome executable to CHROME_EXECUTABLE
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
```

Source ```.zshrc```

```bash
source ~/.zshrc 
```

## Verify flutter installation

Run

```bash
flutter doctor
```

The output for a successful installation should be something like this:

```bash
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.35.3, on Arch Linux 6.16.4-arch1-1, locale en_US.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0-rc1)
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop
[✓] Android Studio (version 2025.1.3)
[✓] Connected device (2 available)
[✓] Network resources

• No issues found!
```