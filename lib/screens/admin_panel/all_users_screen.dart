import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixtex/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Users'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${userData['firstName']} ${userData['lastName'] ?? ""}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${users[index].id}'),
                    // Text('Role: ${userData['role']}'),
                    Text('Created At: ${userData['createdAt'].toDate()}'),
                    // You can add more fields here as required
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData['imageUrl']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
