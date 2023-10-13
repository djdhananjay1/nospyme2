# nospyme2

THIS APPLICATION IS FOR EDUCATIONAL PURPOSES ONLY. ANY OTHER USE IS FULLY PROHIBITED BY ITS MAKER.

A new Flutter project for partenal control from backend.

# Features

* Multiple Child clients
* Hidden app icon (stealth mode)
* Real-time location.
* Recording calls: incoming/outgoing.
* SMS: received/sent.
* Environment recording.
* Take pictures.
* Notifications received: Whatsapp, Instagram, Messenger.

## Getting Started

This project is a starting point for a Flutter application which can be used for partenal control from backend.

A few resources to get you started if this is your first Flutter project:

- You need to setup you firebase server and change for this.
- create 2 users one should be admin and can be just a normal user.
- login with another user on child mobile and as parent keep admin login with you.
- This app uses Location,Notifications,Mic,Camera permissions.

# Build this project

the application work with the api of firebase with which you will have to create a project in firebase and synchronize the application with such project. Firebase API

Enable the following development platforms on firebase: `Authentication`, `realtime database` and `storage`.

* in authentication/sign-in method enable the `email` access provider
* in firebase real-time database assign the following rules:

```java
{
  "rules": {
    ".read": "auth != null",
      ".write": "auth != null"
  }
}
```

* in firebase storage assign the following rules:

```java
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

note: it is very important that accept all the necessary permissions for the application to work properly

# Disclaimer

The Nospyme2 application is intended for legal and educational purposes ONLY. It is a violation of the law to install surveillance software on a mobile phone that you have no right to monitor.

Nospyme2 is not responsible if the user does not follow the laws of the country and goes against it. If it is found that the user violates any law or spy in secret, he will be subject to sanctions that govern the legislation of the country.
