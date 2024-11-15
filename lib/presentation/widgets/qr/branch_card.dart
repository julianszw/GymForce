import 'package:flutter/material.dart';
import 'package:gym_force/domain/branch_domain.dart';

class BranchCard extends StatelessWidget {
  final BranchData branch;
  final bool isSelected;
  final VoidCallback onTap;

  const BranchCard({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.yellow : Colors.transparent,
          width: 3,
        ),
      ),
      child: ListTile(
        title: Text(
          branch.barrio.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
