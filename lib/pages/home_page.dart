import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickchat/auth/auth_service.dart';
import 'package:quickchat/chat/chat_services.dart';
import 'package:quickchat/components/user_tile.dart';
import 'package:quickchat/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void logout() {
    final authService = AuthService();
    authService.logout();
  }

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    PeopleScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QuickChat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(
              Icons.logout,
              color: Colors.yellow.shade900,
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const Text("Loading..."));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: const Text("No users available."));
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }
}

final chatService=ChatServices();
final AuthService authService = AuthService();

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch current user
    final currentUser = authService.getCurrentUser();

    return Column(
      children: [
        const SizedBox(height: 50),
        SafeArea(child: Lottie.asset('animations/ann4.json'),),
        const SizedBox(height: 20),
        // Display user name and email
        Text(
          currentUser?.email ?? 'No email',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

Widget buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  if(userData["email"]!= authService.getCurrentUser()!.email){
    return UserTile(
      text: userData["name"],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(
          recieverEmail: userData["email"],
          recieverName: userData["name"],
          recieverID: userData["uid"],
        )));
      },
    );
  }
  else{
    return Container();
  }
}
