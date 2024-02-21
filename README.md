# skopjeapp

The purpose of this application is to help you find events in the bars and clubs located in Skopje. 

This mobile application was made by: <br />
Angela Mladenovska 201157 <br />
Ivona Tapshanovska 201081 <br />
Matej Popovikj 201194 <br />

Requirements that are implemented: <br />
__Usage of web services__ <br />
    -Firebase is utilized for users authentication, storing events data and storing the uploaded images for the events <br />

__Custom UI elements__ <br />
    - App bar <br />
    - Registration & sign in forms <br />
    - Cards that display the events available <br />
    - Button for more details about the events <br />
    - Dropdown menu for rating an event and button for submitting the rating <br />
    - Map button for redirecting to Google maps <br />
    - Log in/Log out button <br />
    - Button for adding a new event <br />
    - Button for deleting an event <br />

__Software design patterns__ <br />
    - Singleton pattern - by initializing Firebase once for the entire application, called in main.dart <br />
    - Stateful widget pattern - In main.dart, the _EventDetailsScreenState class extends StatefulWidget, representing a screen with mutable state. <br />
    - Factory method pattern - used to create instances <br />
    - Observer pattern - listens to changes and rebuilds the UI when the data changes <br />

__State management__ <br />
    - This app retains state by remembering the registered user's data <br />

__Services__ <br />
    - Location services(Google maps) <br />
    - Camera <br />


__Documentation__ <br />

Requirements for installing the app: Make sure you have **Flutter** and **Dart SDKs** downloaded on your computer. <br />
Run the command **flutter pub get** to fetch dependencies for your Flutter project. <br />
Navigate to the root directory of the project using the command **cd path/to/your/project**. <br />
Execute **flutter run** to run the app. <br />





