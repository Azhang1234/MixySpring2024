import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../localJsonBackend_lijun/drink_request_manager.dart';
import '../../mixy_app_theme.dart'; // Ensure this import is correct for your theme data
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SummaryView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  SummaryView({
    Key? key,
    this.animationController,
    this.animation,
    // required this.imageUrl,
  }) : super(key: key);
  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  String summaryText = '';
  DataManager dataManager = DataManager();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  Future<void> _fetchInfo() async {
    String fetchedInfo = await dataManager.getInfo();
    print(fetchedInfo);
    setState(() {
      summaryText = fetchedInfo;
      _controller.text = summaryText;
    });
  }

  Future<void> _updateInfo() async {
    await dataManager.updateInfo(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _editSummaryText(context);
      },
      child: FadeTransition(
        opacity: widget.animation!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Tap to edit summary',
            ),
            onSubmitted: (value) {
              _updateInfo();
            },
          ),
        ),
      ),
    );
  }

  void _editSummaryText(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Summary'),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter new summary'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // When the user saves their edits, update Firestore
                _updateInfo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
