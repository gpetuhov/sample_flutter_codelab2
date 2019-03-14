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
    // Wrap Container with input text and button inside IconTheme
    // to set color of the send button.
    return IconTheme(
      // This changes color of send button icon to the accent color of the app's theme.
      // A BuildContext object is a handle to the location of a widget in your app's widget tree.
      // Each widget has its own BuildContext, which becomes the parent of the widget returned
      // by the StatelessWidget.build or State.build function.
      // This means the _buildTextComposer() method can access the BuildContext object
      // from its encapsulating State object; you don't need to pass the context to the method explicitly.
      data: IconThemeData(color: Theme.of(context).accentColor),
      // Container widget adds a horizontal margin between
      // the edge of the screen and each side of the input field
      child: Container(
        // The units here are logical pixels that get translated into
        // a specific number of physical pixels, depending on a device's pixel ratio.
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        // We need Row to display the button adjacent to the input field
        child: Row(
          children: <Widget>[
            // Flexible tells the Row to automatically size the text field
            // to use the remaining space that isn't used by the button.
            Flexible(
              // TextField handles the mutable text content
              child: TextField(
                controller: _textController,
                onSubmitted:
                    _handleSubmitted, // this is triggered when pressing OK on the keyboard
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            // We place send button inside the Container to specify margins
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  // This is triggered on button pressed.
                  // TextEditingController keeps entered text.
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    // TextField clear is done by TextEditingController
    _textController.clear();
  }
}

class ChatMessage extends StatelessWidget {

  ChatMessage({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // For the avatar, the parent is a Row widget whose main axis is horizontal,
          // so CrossAxisAlignment.start gives it the highest position along the vertical axis.
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // For messages, the parent is a Column widget whose main axis is vertical,
              // so CrossAxisAlignment.start aligns the text at the furthest left position
              // along the horizontal axis.
              // Using current theme allows us to avoid hard-coding font sizes and other text attributes.
              Text(_name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const String _name = "User Name";
