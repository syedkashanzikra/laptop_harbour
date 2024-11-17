import 'package:flutter/material.dart';
import 'package:lhstore/utils/constants/colors.dart';

class RefundPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refund Policy"),
        backgroundColor: LHColor.primary1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LHColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LaptopHarbour Refund Policy",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LHColor.primary1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your satisfaction is our priority. Please review our policy below.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPolicySection(
                    title: "1. Eligibility for Refunds",
                    description:
                        "You may request a refund within 30 days of receiving your product. The product must be unused and in its original packaging.",
                  ),
                  _buildPolicySection(
                    title: "2. Refund Process",
                    description:
                        "To initiate a refund, contact our support team. Upon approval, please send the item back to our facility.",
                  ),
                  _buildPolicySection(
                    title: "3. Exceptions",
                    description:
                        "Certain items may not be eligible for refunds, including custom orders and items on final sale.",
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add any further action like contact support
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: LHColor.primary1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Contact Support",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: LHColor.primary1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
