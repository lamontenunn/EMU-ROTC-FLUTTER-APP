// create_channel_screen.dart
import 'package:flutter/material.dart';

class CreateChannelScreen extends StatefulWidget {
  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  TextEditingController _channelNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Channel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _channelNameController,
              decoration: InputDecoration(
                labelText: 'Channel Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final channelName = _channelNameController.text;
                if (channelName.isNotEmpty) {
                  // Save the channel to Firestore
                }
              },
              child: Text('Create Channel'),
            ),
          ],
        ),
      ),
    );
  }
}
