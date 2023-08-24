# Doctor Appointment App with Flutter and Firebase

Appointment scheduling module for an application connecting doctors with their patients.


## Functionality: 

- A User can signup with one of the roles: Doctor or Patient
- A Patient can: 
  - View a list of doctors, chose one of Doctor's available timeslots and schedule an appointment
  - View their forthcoming appointments
  - Cancel and reschedule their appointment
- A Doctor can:
  - View their forthcoming appointments
  - Approve scheduled appointment
- Patient an Doctor get a reminder 1 day before scheduled appointment
- Doctor gets a push notification about new appointment

![image](https://github.com/yankovskaya-ktr/doctor_appointment/assets/82261797/6990b935-7a18-4a20-ab06-42bd999ef5e3)
![image](https://github.com/yankovskaya-ktr/doctor_appointment/assets/82261797/0baff314-2ffe-4f46-a7d2-03d8a01f91b3)
![image](https://github.com/yankovskaya-ktr/doctor_appointment/assets/82261797/203c3878-bbc8-441a-8ea2-260ba138d557)


## Technologies:

- **Riverpod** for state management and dependency injection
- **GoRouter** for navigation
- **Firebase Auth** for authentication with email and password
- **Cloud Firestore** as a database
- **Firebase Cloud Messaging** and **Firebase Cloud Functions** (see `/functions` dir) for push notifications on new appointments
- **Flutter Local Notifications** for reminder notifications about scheduled appointments


## Running the project:

1. Set up a Firebase project with the [Firebase console](https://console.firebase.google.com/):

    - Create a new project
    - Enable Firebase Authentication and the Email/Password Authentication Sign-in provider in the Firebase Console
    - Enable Cloud Firestore

2. Register the project with Firebase:
   
  - Install the [Firebase CLI](https://firebase.google.com/docs/cli) and [FlutterFire CLI](https://pub.dev/packages/flutterfire_cli)
  - Add Firebase to the Flutter project following [documentation](https://firebase.google.com/docs/flutter/setup?platform=android)

3. Set up Firebase Cloud Functions (for push notifications):
   
  - Install Node.js and npm
  - Initialize Firebase Cloud Functions for the project following [documentation](https://firebase.google.com/docs/functions/get-started?gen=2nd#initialize-your-project)
  - Install dependencies locally by running: `cd functions`, `npm install`
  - Deploy the project by running `firebase deploy`
   








