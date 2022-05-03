# Realiteye

Project for Design and Implementation of Mobile Applications (DIMA) course of Politecnico di Milano.

Authors: Nicolò Albergoni, Andrea Falanti.

## Description

Realiteye is a prototype application for an e-commerce integrated with augmented reality (AR) services.
Augmented reality integration allows users to view the products directly in the surroundings, which can be valuable for various kind of products like furnitures or decors to get an estimate of their dimensions and on how they integrate in the environment.
This project does not focus on exploiting all the potentiality of augmented reality applications, but instead focus on the general design and user experience since it was the main goal of the exam, but could be a good starting point for a real application deployment.

The application has been tested on various Android versions, using dummy data generated through our seed script to populate the application, simulating a real case scenario. The majority of the code is cross-platform, but some plugins could require some adjustments to work properly on iOS.

## Technologies

Realiteye has been developed with [Flutter](https://flutter.dev/), a framework for multi-platform mobile development.
The application structure is based on Model-View-Presenter (MVP) pattern, using [Redux](https://redux.js.org/) as state manager.
The AR scene has been developed with [Unity](https://unity.com/) and integrated inside Flutter as a widget.
The backend is provided through [Firebase](https://firebase.google.com/) services, in particular Cloud Firestore, Firebase Authentication and Cloud Storage.

To learn more about the application design, check the design document provided in __documentation__ folder.

## Commands

Use this command to install the project dependencies:
```
flutter pub get
```

To produce and install the APK, refer to the [official documentation](https://docs.flutter.dev/deployment/android).

Generate translation keys using this command:
```
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S assets/translations
```
