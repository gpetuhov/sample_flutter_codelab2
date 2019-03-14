import 'package:flutter/material.dart';

void main() {
  runApp(FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  // TextEditingController is used to manage interactions with the text field
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friendlychat")),
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    // Container widget adds a horizontal margin between
    // the edge of the screen and each side of the input field
    return Container(
      // The units here are logical pixels that get translated into
      // a specific number of physical pixels, depending on a device's pixel ratio.
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      // TextField handles the mutable text content
      child: TextField(
        controller: _textController,
        onSubmitted: _handleSubmitted,
        decoration: InputDecoration.collapsed(hintText: "Send a message"),
      ),
    );
  }

  void _handleSubmitted(String text) {
    // TextField clear is done by TextEditingController
    _textController.clear();
  }
}
