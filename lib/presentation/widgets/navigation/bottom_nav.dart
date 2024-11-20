import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/screens/calories_screen.dart';
import 'package:gym_force/presentation/screens/home_screen.dart';
import 'package:gym_force/presentation/screens/profile_screen.dart';
import 'package:gym_force/presentation/screens/qr_customer_screen.dart';
import 'package:gym_force/presentation/screens/workouts_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, required Widget child});

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.push('/');
        break;
      case 1:
        context.push('/workouts');
        break;
      case 2:
        context.push('/qr');
        break;
      case 3:
        context.push('/calories');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onItemTapped(2),
            child: const Icon(
              Icons.qr_code,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        color: Colors.black,
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.fitness_center, 'Rutinas', 1),
            const SizedBox(width: 50),
            _buildNavItem(Icons.local_fire_department, 'Calorías', 3),
            _buildNavItem(Icons.person, 'Perfil', 4),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const WorkoutsScreen();
      case 2:
        return BranchListScreen();
      case 3:
        return const CaloriesScreen();
      case 4:
        return const ProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color iconColor =
        isSelected ? Theme.of(context).colorScheme.primary : Colors.white;
    Color textColor =
        isSelected ? Theme.of(context).colorScheme.primary : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: () => _onItemTapped(index),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
