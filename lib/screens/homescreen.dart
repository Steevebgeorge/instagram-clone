import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/addpost.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/screens/searchscreen.dart';
import 'package:instagram/services/authmethods.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    addData();
    getuserData();
    // _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  addData() async {
    try {
      UserProvider userprovider =
          Provider.of<UserProvider>(context, listen: false);
      await userprovider.refreshUser();
    } catch (e) {
      log(e.toString());
    }
  }

  void navigationTap(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  void getuserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          _userId = currentUser.uid;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      String result = await Authentication().signout();

      if (context.mounted) {
        if (result == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully logged out')),
          );
        } else {
          throw Exception(result);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPost(),
          const Text("Notifications"),
          ProfileScreen(
            uid: _userId!,
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: navigationTap,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined),
              label: 'Add a photo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
