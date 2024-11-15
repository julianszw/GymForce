// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class BottomNav extends StatefulWidget {
//   final Widget child; // Agregamos el `child` para renderizar la pantalla activa

//   const BottomNav({super.key, required this.child});

//   @override
//   _BottomNavState createState() => _BottomNavState();
// }

// class _BottomNavState extends State<BottomNav> {
//   int _selectedIndex = 0;

//   // Método para cambiar entre las páginas del BottomNavigationBar
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         context.push('/'); // Home
//         break;
//       case 1:
//         context.push('/workouts'); // Workouts
//         break;
//       case 2:
//         context.push('/qr'); // QR
//         break;
//       case 3:
//         context.push('/calories'); // Calories
//         break;
//       case 4:
//         context.push('/profile'); // Profile
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.child, // Renderizamos la pantalla activa
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Color(121212), // Color negro para la barra
//         selectedItemColor: Colors.yellow,
//         unselectedItemColor: Colors.white,
//         showUnselectedLabels: true,

//         items: [
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Entrenamientos',
//           ),
//           BottomNavigationBarItem(
//             icon: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Círculo amarillo
//                 Container(
//                   width: 70, // Ancho del círculo
//                   height: 70, // Alto del círculo
//                   decoration: const BoxDecoration(
//                     color: Colors.yellow, // Color del círculo
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black54,
//                         offset: Offset(0, 5), // Sombra hacia abajo
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Ícono de QR
//                 const Icon(
//                   Icons.qr_code,
//                   size: 30, // Tamaño del ícono
//                   color: Colors.black, // Color del ícono
//                 ),
//               ],
//             ),
//             label: '',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.local_fire_department),
//             label: 'Calorías',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Perfil',
//           ),
//         ],
//       ),
//     );
//   }
// }
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
            _buildNavItem(Icons.fitness_center, 'Workouts', 1),
            const SizedBox(width: 50),
            _buildNavItem(Icons.local_fire_department, 'Calories', 3),
            _buildNavItem(Icons.person, 'Profile', 4),
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
