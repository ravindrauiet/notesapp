import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../constants/app_constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                Icon(
                  MdiIcons.lightbulb,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.lightbulb,
                  title: AppStrings.notes,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to notes
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.bellOutline,
                  title: AppStrings.reminders,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to reminders
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.pencilOutline,
                  title: AppStrings.editLabels,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to labels
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.archiveOutline,
                  title: AppStrings.archiveTitle,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to archive
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.deleteOutline,
                  title: AppStrings.trash,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to trash
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Keep Clone v${AppConstants.appVersion}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
