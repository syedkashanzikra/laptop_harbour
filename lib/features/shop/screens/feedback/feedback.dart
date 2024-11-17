import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lhstore/navigation_menu.dart';

import 'package:lhstore/utils/constants/colors.dart';
import 'package:rive/rive.dart';
 // Import your profile screen here

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _rating = 0;
  bool _isSubmitting = false;
  bool _showSuccessAnimation = false;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      await FirebaseFirestore.instance.collection('feedback').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'subject': _subjectController.text,
        'message': _messageController.text,
        'rating': _rating,
        'timestamp': Timestamp.now(),
      });

      // Clear form fields after submission
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _rating = 0;
        _showSuccessAnimation = true;
      });

      // Show animation for 2 seconds, then navigate
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _showSuccessAnimation = false;
        });
        _navigateToProfileScreen();
      });
    }
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NavigationMenu(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: LHColor.primary1,
      ),
      body: _showSuccessAnimation
          ? Center(
              child: RiveAnimation.asset(
                'assets/animations/success.riv',
                fit: BoxFit.cover,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We value your feedback!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: LHColor.primary1,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField("Name", _nameController, "Please enter your name"),
                      _buildTextField("Email", _emailController, "Please enter a valid email",
                          keyboardType: TextInputType.emailAddress),
                      _buildTextField("Subject", _subjectController, "Please enter a subject"),
                      _buildTextField("Message", _messageController, "Please enter your message",
                          maxLines: 5),
                      SizedBox(height: 20),
                      _buildRatingSection(),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: LHColor.primary1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Submit Feedback",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String errorMessage,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: LHColor.primary1,
            ),
          ),
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.black), // Set text color to black
            validator: (value) {
              if (value == null || value.isEmpty) {
                return errorMessage;
              }
              if (label == "Email" && !RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate Us",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: LHColor.primary1,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < _rating ? Colors.yellow : Colors.grey,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
