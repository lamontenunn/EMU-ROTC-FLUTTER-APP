import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'create_channel_screen.dart';
import 'user_model.dart';

class GroupChatPage extends StatefulWidget {
  final UserModel user;

  GroupChatPage({required this.user});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late Future<List<QueryDocumentSnapshot>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _channelsFuture = getChannelsForUser(widget.user);
  }

  Future<List<QueryDocumentSnapshot>> getChannelsForUser(UserModel user) async {
    final channelsRef = FirebaseFirestore.instance.collection('channels');
    final query = channelsRef.where('members', arrayContains: user.uid);
    final querySnapshot = await query.get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _channelsFuture,
        builder: (context, snapshot) {
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateChannelScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          );
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data![index];
                  final channelId = doc.id;
                  final channelName = doc['name'];

                  return ListTile(
                    title: Text(channelName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(channelId: channelId),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

Future<void> saveChannel(String channelName, List<String> members) async {
  final channelsRef = FirebaseFirestore.instance.collection('channels');
  await channelsRef.add({
    'name': channelName,
    'members': members,
  });
}



  
}
