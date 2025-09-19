import 'package:flutter/material.dart';
import 'package:moonestate/screens/listings/listing.dart';
import 'package:moonestate/screens/projects/projects.dart';
import 'package:moonestate/utils/image_utilies.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import 'property_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    PropertyListScreen(),
    Listing(),
    Projects(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2), // shadow goes up
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff7065EF),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(AssetsImage.bottomHome, scale: 4),
              activeIcon: Image.asset(
                AssetsImage.bottomHome,
                scale: 4,
                color: Color(0xff7065EF),
              ),
              label: languageProvider.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AssetsImage.listings, scale: 4),
              activeIcon: Image.asset(
                AssetsImage.listings,
                scale: 4,
                color: Color(0xff7065EF),
              ),
              label: languageProvider.translate('Listings'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AssetsImage.projects, scale: 4),
              activeIcon: Image.asset(
                AssetsImage.projects,
                scale: 4,
                color: Color(0xff7065EF),
              ),
              label: languageProvider.translate('Projects'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AssetsImage.profile, scale: 4),
              activeIcon: Image.asset(
                AssetsImage.profile,
                scale: 4,
                color: Color(0xff7065EF),
              ),
              label: languageProvider.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
