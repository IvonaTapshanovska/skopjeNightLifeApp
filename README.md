# skopjeapp

The purpose of this application is to help you find events in the bars and clubs located in Skopje. 

This mobile application was made by:
Angela Mladenovska 201157
Ivona Tapshanovska 201081
Matej Popovikj 201194

Requirements that are implemented:
__Usage of web services__
    -Firebase is utilized for users authentication, storing events data and storing the uploaded images for the events

__Custom UI elements__
    - App bar
    - Registration & sign in forms
    - Cards that display the events available 
    - Button for more details about the events
    - Dropdown menu for rating an event and button for submitting the rating
    - Map button for redirecting to Google maps
    - Log in/Log out button
    - Button for adding a new event
    - Button for deleting an event

__Software design patterns__
    - Singleton pattern - by initializing Firebase once for the entire application, called in main.dart
    - Stateful widget pattern - In main.dart, the _EventDetailsScreenState class extends StatefulWidget, representing a screen with mutable state. 
    - Factory method pattern - used to create instances
    - Observer pattern - listens to changes and rebuilds the UI when the data changes

__State management__
    - This app retains state by remembering the registered user's data 

__Services__
    - Location services(Google maps)
    - Camera


__Documentation__

Requirements for installing the app: Make sure you have **Flutter** and **Dart SDKs** downloaded on your computer.
Run the command **flutter pub get** to fetch dependencies for your Flutter project.
Navigate to the root directory of the project using the command **cd path/to/your/project**.
Execute **flutter run** to run the app.





