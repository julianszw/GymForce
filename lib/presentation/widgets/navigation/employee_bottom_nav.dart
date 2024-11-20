import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/screens/employee/employee_welcome.dart';
import 'package:gym_force/presentation/screens/employee/help_screen.dart'; //antes ayuda
import 'package:gym_force/presentation/screens/employee/qr_employee_screen.dart';
import 'package:gym_force/presentation/screens/profile_screen.dart';

class EmployeeBottomNav extends StatefulWidget {
  const EmployeeBottomNav({super.key, required Widget child});

  @override
  EmployeeBottomNavState createState() => EmployeeBottomNavState();
}

class EmployeeBottomNavState extends State<EmployeeBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.push('/employee-welcome');
        break;
      case 1:
        context.push('/qr-employee');
        break;
      case 2:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onItemTapped(1),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.notifications, 'Ayuda', 0),
            const SizedBox(width: 50),
            _buildNavItem(Icons.person, 'Perfil', 2),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const EmployeeWelcomeScreen();
      case 1:
        return const QrEmployeeScreen();
      case 2:
        return const ProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color iconColor = isSelected ? Colors.yellow : Colors.white;
    Color textColor = isSelected ? Colors.yellow : Colors.white;

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
