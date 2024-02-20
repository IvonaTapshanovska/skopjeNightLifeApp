import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:skopjeapp/firebase_options.dart';
import 'package:skopjeapp/widgets/map_page.dart';
import 'models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/event_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Montserrat',
      ),
    );
  }
}

class EventDetailsScreen extends StatefulWidget {
  final EventInfo event;

  EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}
class _EventDetailsScreenState extends State<EventDetailsScreen>{

  late GoogleMapController mapController;
  late String selectedRating;
  late bool userLoggedIn;
  late List<int> ratings;
  late EventInfo event;

  @override
  void initState(){
    event = widget.event;
    super.initState();
    selectedRating='1';
    userLoggedIn=FirebaseAuth.instance.currentUser!=null;
    ratings=[];
    _fetchRatings();

  }


  // Add this method to fetch ratings from Firestore
  Future<void> _fetchRatings() async {
    try {
      // Query Firestore to get the document by eventName
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventName', isEqualTo: widget.event.eventName)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // Set the ratings based on the data from Firestore
          ratings = List<int>.from(querySnapshot.docs.first['rating'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:Text(

          widget.event.clubName,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        actions: [
          FutureBuilder<List<String>>(
            future: _getUserRoles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bool isAdmin = snapshot.data?.contains('admin') ?? false;

                if (isAdmin) {
                  return IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: () {
                      _confirmDeleteEvent(context,event);
                    },
                  );
                }
              }

              return const SizedBox.shrink(); // If not an admin, return an empty SizedBox
            },
          ),
        ],

      ),
      backgroundColor: Colors.indigo,
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: widget.event.pictureUrl.isNotEmpty
                    ? Image.network(
                  File(widget.event.pictureUrl).path,
                  fit: BoxFit.cover,
                )
                    : const Text('No Image Available'),
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Club Name:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.event.clubName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Name:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.event.eventName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.event.location,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      DateFormat('yyyy-MM-dd   HH:mm').format(widget.event.dateTime),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minimum Age:',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.event.minAge.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),



              const Divider(),
              if (userLoggedIn)
                DropdownButton<int>(
                  value: int.parse(selectedRating),
                  onChanged: (value) {
                    setState(() {
                      selectedRating = value.toString();
                    });
                  },
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Rating: $value'),
                    );
                  }).toList(),
                ),

              if (userLoggedIn)
                ElevatedButton(
                  onPressed: () {
                    _submitRating();
                  },
                  child: const Text('Submit Rating'),
                ),


              const Divider(),
              Center(
                child: SizedBox(
                  width: 300, // Adjust width as needed
                  height: 300, // Adjust height as needed
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Optional: Add border radius
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.event.lat, widget.event.lon), // Use your event's coordinates
                        zoom: 18,
                      ),
                      markers: Set<Marker>.from([
                        Marker(
                          markerId: MarkerId('event_marker'),
                          position: LatLng(widget.event.lat, widget.event.lon), // Use your event's coordinates
                        ),
                      ]),
                    ),
                  ),
                ),

              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(event: widget.event,),
                      ),
                    );
                  },
                  child: const Text('Map'),
                ),
              )


            ],
          ),
        ),
      ),
    );

  }

  Future<List<String>> _getUserRoles() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          // Assuming roles are stored as an array in the 'roles' field
          List<String> userRoles = List<String>.from(userSnapshot['roles']);
          return userRoles;
        }
      }

      // If user is null or document doesn't exist, return an empty list
      return [];
    } catch (e) {
      print("Error getting user roles: $e");
      return [];
    }
  }





  void _confirmDeleteEvent(BuildContext context, EventInfo event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              _deleteEventByName(event.clubName);

            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<String?> getEventIdByName(String clubName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('clubName', isEqualTo: clubName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {

        return null;
      }
    } catch (e) {
      print('Error getting event ID by name: $e');
      return null;
    }
  }




  void _deleteEventByName(String eventName) async {
    try {
      // Get the event ID by name
      String? eventId = await getEventIdByName(eventName);

      if (eventId != null) {
        // If the event ID is found, delete the event
        await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
        print('Event deleted successfully.');
      } else {
        print('Event not found or an error occurred while getting the ID.');
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }


  void _submitRating() async {
    try {
      int ratingValue = int.parse(selectedRating);

      // Query Firestore to get the document by eventName
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventName', isEqualTo: widget.event.eventName)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the existing ratings array or initialize an empty list
        List<int> existingRatings =
        List<int>.from(querySnapshot.docs.first['rating'] ?? []);

        // Add the new rating to the existing ratings list
        existingRatings.add(ratingValue);

        // Update the rating in the Firestore database
        await FirebaseFirestore.instance
            .collection('events')
            .doc(querySnapshot.docs.first.id)
            .update({
          'rating': FieldValue.arrayUnion(existingRatings),
        });

        // Show a success message or handle the submission as needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating submitted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Document not found
        print('Error: Document not found for eventName: ${widget.event.eventName}');
      }
    } catch (e) {
      // Handle any potential errors
      print("Error submitting rating: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting rating. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }





}

class MainListScreen extends StatefulWidget {
  const MainListScreen({Key? key});

  @override
  MainListScreenState createState() => MainListScreenState();
}

class MainListScreenState extends State<MainListScreen> {
  late FirebaseFirestore _firestore;
  CollectionReference get events => _firestore.collection('events');

  TextEditingController clubController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController minAgeController = TextEditingController();

  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  String pictureUrl = ''; // Set the picture URL accordingly

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events in Skopje',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          FutureBuilder<List<String>>(
            // Assuming you have the _getUserRoles function
            future: _getUserRoles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Check if the user has the 'admin' role
                bool isAdmin = snapshot.data?.contains('admin') ?? false;

                if (isAdmin) {
                  return IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white70,
                    ),
                    onPressed: () => _addEventFunction(context),
                  );
                }
              }

              return SizedBox.shrink(); // If not an admin, return an empty SizedBox
            },
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.login,
                  color: Colors.white70,
                ),
                onPressed: () => FirebaseAuth.instance.currentUser != null
                    ? _signOut()
                    : _navigateToSignInPage(context),
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.grey[400],
        height: MediaQuery.of(context).size.height * 1.0,
        child: StreamBuilder<QuerySnapshot>(
          stream: events.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final eventsList = snapshot.data!.docs
                .map((event) =>
                EventInfo.fromMap(event.data() as Map<String, dynamic>))
                .toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                final event = eventsList[index];
                return buildEventWidget(context, event);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildEventWidget(BuildContext context, EventInfo event) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 200,
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Club Name: ${event.clubName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Event Name: ${event.eventName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Location: ${event.location}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd    HH:mm').format(event.dateTime),
                        // Format the date and time using DateFormat
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Minimum Age: ${event.minAge}',
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the event details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: event),
                        ),
                      );
                    },
                    child: Text('Details'),
                  ),
                ],
              ),
              if (event.pictureUrl.isNotEmpty)
                Expanded(
                    child:

                    Image.network(
                      event.pictureUrl,
                      width: 371,
                      height: 250,
                      fit: BoxFit.cover,
                    ) )
              else
                Text('No Image Selected'),
              SizedBox(height: 10),

            ],
          ),
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

  Future<List<String>> _getUserRoles() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          // Assuming roles are stored as an array in the 'roles' field
          List<String> userRoles = List<String>.from(userSnapshot['roles']);
          return userRoles;
        }
      }

      // If user is null or document doesn't exist, return an empty list
      return [];
    } catch (e) {
      print("Error getting user roles: $e");
      return [];
    }
  }

  Future<void> _addEventFunction(BuildContext context) async {
    List<String> userRoles = await _getUserRoles();

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
      },
    );

  }

  void _addEvent(EventInfo event) async {
    await events.add(event.toMap());
    Navigator.pop(context);
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        UserCredential userCredential= await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        _successDialog("You have successfully logged in");
        _navigateToHomePage();
      } else {
        UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User? user = FirebaseAuth.instance.currentUser;
        if(user!=null)
        {
          if(_emailController.text.toLowerCase().contains('admin'))
          {
            await firestore.collection('users').doc(userCredential.user!.uid).set({
              'email':_emailController.text,
              'roles': ['admin'],
            });
          }
          else
          {
            await firestore.collection('users').doc(userCredential.user!.uid).set({
              'email': _emailController.text,
              'roles': ['user'],
            });
          }
        }
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
      backgroundColor: Colors.indigo,
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
        color: const Color.fromARGB(255, 220, 220, 220), // You can choose any color you prefer
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Make the email text bold
              const Text(
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
              const Text(
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,  // Button text color
                ),
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