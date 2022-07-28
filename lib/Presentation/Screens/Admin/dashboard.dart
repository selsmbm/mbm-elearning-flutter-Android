import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/Data/Repository/post_material_repo.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Admin Dashboard");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AddDataToApiBloc(
                      PostMaterialRepo(),
                    ),
                    child: const AddMaterialPage(
                      approveStatus: 'true',
                    ),
                  ),
                ),
              );
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Add new material'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'approvematerialPage');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Unapproved Material'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'addNewExplore');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Add new explore'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'addNewEvent');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Add new event'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'addNewFeed');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Add new feed post with notification'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'sendnotitoall');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Send only notification to all'),
          ),
          ListTile(
            onTap: () {
              launch(
                  "https://www.google.com/maps/d/edit?mid=1_Wg8w4EujrRyn9PHpoZdT1pvy73Pwvc&usp=sharing");
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            title: const Text('Edit mbmu campus map'),
          ),
        ],
      ),
    );
  }
}
