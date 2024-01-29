import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skopjeapp/firebase_options.dart';
import 'models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/event_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
      theme: ThemeData(primaryColor: Colors.blue,
        fontFamily: 'Montserrat', ),
    );
  }
}

class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  MainListScreenState createState() => MainListScreenState();
}

class MainListScreenState extends State<MainListScreen> {
  final List<EventInfo> events = [
    EventInfo(clubName: "Happy caffe", eventName: "DJ dj", location: "Aerodrom,Skopje",
    dateTime: DateTime.now(), minAge: 18, pictureUrl: "photos/party.jpg"),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
    title: const Text('Events in Skopje'),
    actions: [
      Row(
        children: [
          //const Text('Add a new course:'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => FirebaseAuth.instance.currentUser != null
                ? _addEventFunction(context)
                : _navigateToSignInPage(context),
          ),
         
        ],
      ),
      Row(
        children: [
          //const Text("Log out:"),
      IconButton(
        icon: const Icon(Icons.login),
        onPressed: _signOut,
      ),    
    ],
      )
    ]
  ),
     body: Container(
      height: MediaQuery.of(context).size.height * 1.0, // Adjust the value as needed
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final clubName = events[index].clubName;
          final eventName = events[index].eventName;
          final location = events[index].location;
          final dateTime = events[index].dateTime;
          final minAge = events[index].minAge;
          final pictureUrl = events[index].pictureUrl;

          return Container(
            width: MediaQuery.of(context).size.width * 0.5, // Adjust the value as needed
            height: 50, // Set a fixed height for each card
            child: Card(
              color: Colors.lightBlue,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Club Name: $clubName'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Event Name: $eventName'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Location: $location'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(dateTime.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Minimum Age: $minAge'),
                    ],
                  ),
                  Row(
              children: [
              Image.asset(
                  pictureUrl,
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
              ],
            ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> _addEventFunction(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: EventWidget(
              addEvent: _addEvent,
            ),
          );
        });
  }

  void _addEvent(EventInfo event) {
    setState(() {
      events.add(event);
    });
  }
}

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _successDialog("You have successfully logged in");
        _navigateToHomePage();
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _successDialog("Your registration is successful");
        _navigateToLoginPage();
      }
    } catch (e) {
      _errorDialog("Authentication Error. Please try again");
    }
  }

  void _successDialog(String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _errorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
     
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomePage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _navigateToLoginPage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _navigateToRegisterPage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isLogin ? const Text("Log in") : const Text("Sign up"),
      ),
      body: Container(
        // Set the background color for the login page
        color: Color.fromARGB(255, 220, 220, 220), // You can choose any color you prefer
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Make the email text bold
              Text(
                "Email",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // Bold
                ),
              ),
              TextField(
                controller: _emailController,
                //decoration: const InputDecoration(labelText: "Enter your email"),
              ),
              const SizedBox(height: 20),
              // Make the password text bold
              Text(
                "Password",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // Bold
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                //decoration: const InputDecoration(labelText: "Enter your password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authAction,
                child: Text(widget.isLogin ? "Sign In" : "Register"),
              ),
              if (!widget.isLogin)
                ElevatedButton(
                  onPressed: _navigateToLoginPage,
                  child: const Text('Already have an account? Login'),
                ),
              if (widget.isLogin)
                ElevatedButton(
                  onPressed: _navigateToRegisterPage,
                  child: const Text('Create an account'),
                ),
              TextButton(
                onPressed: _navigateToHomePage,
                child: const Text('Back to Main Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
