import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/Data/Repository/post_material_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
              color: Colors.black,
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
              color: Colors.black,
              size: 20,
            ),
            title: const Text('Unapproved Material'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'addNewFeed');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
            title: const Text('Add new explore'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'addNewFeed');
            },
            leading: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
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
              color: Colors.black,
              size: 20,
            ),
            title: const Text('Add new feed post'),
          ),
        ],
      ),
    );
  }
}
