import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      // Customize theme depending on the current platform
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

// TickerProviderStateMixin is needed for animation
// (to use ChatScreenState as the vsync),
// In Dart, a mixin allows a class body to be reused in multiple class hierarchies.
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // TextEditingController is used to manage interactions with the text field
  final TextEditingController _textController = TextEditingController();

  // Stores chat messages
  final List<ChatMessage> _messages = <ChatMessage>[];

  // true if input text is not empty
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friendlychat"),
        // Set elevation depending on current platform
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      // This Container widget is needed to give its child a light grey border on its upper edge.
      // This border will help visually distinguish the app bar from the body of the app on iOS.
      // To hide the border on Android, set decoration to null on Android.
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                // Naming the argument "_" is a convention to indicate that it won't be used
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              // BoxDecoration object defines the background color.
              // In this case we're using the cardColor defined by the ThemeData object of the current theme.
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      // It's good practice to dispose of your animation controllers
      // to free up your resources when they are no longer needed.
      message.animationController.dispose();
    }
    super.dispose();
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
                // This is triggered every time text changes
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted:
                    _handleSubmitted, // this is triggered when pressing OK on the keyboard
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            // We place send button inside the Container to specify margins
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                // For iOS use CupertinoButton, for Android use IconButton
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: new Icon(Icons.send),
                        // This is triggered on button pressed.
                        // TextEditingController keeps entered text.
                        // Set function to be triggered, if _isComposing == true only.
                        // If widget's onPressed property is set to null, button will be disabled
                        // and the framework will automatically change the button's color
                        // to Theme.of(context).disabledColor.
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    // TextField clear is done by TextEditingController
    _textController.clear();

    // This is needed to "disable" send button after send message
    setState(() {
      _isComposing = false;
    });

    ChatMessage message = ChatMessage(
      text: text,
      // The AnimationController class lets you define important characteristics of the animation,
      // such as its duration and playback direction (forward or reverse).
      animationController: AnimationController(
        duration: Duration(
            milliseconds: 700), // In production set shorter duration period
        // The vsync prevents animations that are offscreen from consuming unnecessary resources
        vsync: this,
      ),
    );

    setState(() {
      // Only synchronous operations should be performed in setState(),
      // because otherwise the framework could rebuild the widgets before the operation finishes

      // New message goes first
      _messages.insert(0, message);
    });

    // Specify that the animation should play forward whenever a new message is added to the chat list
    message.animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    // The SizeTransition class provides an animation effect where the width or height
    // of its child is multiplied by a given size factor value.
    return SizeTransition(
      sizeFactor:
          // The CurvedAnimation object, in conjunction with the SizeTransition class,
          // produces an ease-out animation effect. The ease-out effect causes the message
          // to slide in quickly at the beginning of the animation and slow down until it comes to a stop.
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
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
            // This is needed to wrap longer lines.
            // Expanded allows a widget like Column to impose layout constraints
            // (in this case the Column's width), on a child widget.
            // Here it constrains the width of the Text widget, which is normally determined by its contents.
            Expanded(
              child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}

const String _name = "User Name";

// Theme for iOS
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

// Theme for Android
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);
