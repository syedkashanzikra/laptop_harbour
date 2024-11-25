import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http; // For API requests
import 'package:lhstore/admin/screens/admin_product/admin_product_page.dart';
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class AddProductAdmin extends StatefulWidget {
  @override
  _AddProductAdminState createState() => _AddProductAdminState();
}

class _AddProductAdminState extends State<AddProductAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productWeightController =
      TextEditingController();
  final TextEditingController _productDiscountController =
      TextEditingController();

  Uint8List? _productImage; // To store the selected image
  bool _isUploading = false; // Tracks upload progress

  List<Map<String, dynamic>> _categories = []; // Dynamic categories
  String? _selectedCategoryKey; // Selected category key

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories when the screen loads
  }

  // Fetch categories from Firebase
  Future<void> _fetchCategories() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref("Categories");
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final categories = data.entries.map((entry) {
          return {"key": entry.key, "name": entry.value["name"]};
        }).toList();

        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      LHLoader.ErrorSnackBar(
          title: "Error", message: "Failed to fetch categories: $e");
    }
  }

  // Method to pick an image from the gallery
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _productImage = imageBytes; // Save the image bytes for preview
      });
    }
  }

  // Upload image to ImgBB API
  Future<String?> _uploadImageToImgBB() async {
    if (_productImage == null) return null;

    const String apiKey =
        "1a17fbc4c53e8e20d5502fe02bf707dd"; // Replace with your ImgBB API key
    final url = Uri.parse("https://api.imgbb.com/1/upload");

    try {
      final response = await http.post(
        url,
        body: {
          "key": apiKey,
          "image": base64Encode(_productImage!), // Encode image as Base64
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]["url"]; // Return the image URL
      } else {
        LHLoader.ErrorSnackBar(
            title: "Error", message: "Image upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      LHLoader.ErrorSnackBar(
          title: "Error", message: "Failed to upload image: $e");
      return null;
    }
  }

  // Add product to Firebase Realtime Database
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_productImage == null) {
      LHLoader.WarningSnackBar(
          title: "Warning", message: "Please select a product image");
      return;
    }

    if (_selectedCategoryKey == null) {
      LHLoader.WarningSnackBar(
          title: "Warning", message: "Please select a category");
      return;
    }

    double? price;
    int? stock;
    double? weight;
    double? discount;

    try {
      price = double.parse(_productPriceController.text);
      stock = int.parse(_productStockController.text);
      weight = double.parse(_productWeightController.text);
      discount = _productDiscountController.text.isNotEmpty
          ? double.parse(_productDiscountController.text)
          : 0.0;
    } catch (e) {
      LHLoader.ErrorSnackBar(
          title: "Error", message: "Please enter valid numeric values.");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageUrl = await _uploadImageToImgBB();

    if (imageUrl == null) {
      setState(() {
        _isUploading = false;
      });
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref("Products");
    try {
      await dbRef.push().set({
        "name": _productNameController.text,
        "description": _productDescriptionController.text,
        "price": price,
        "stock": stock,
        "weight": weight,
        "category": _categories.firstWhere(
            (category) => category["key"] == _selectedCategoryKey)["name"],
        "discount": discount,
        "imageUrl": imageUrl,
      });

      LHLoader.successSnackBar(
          title: "Success", message: "Product added successfully");
      _redirectToProductAdminView();
    } catch (e) {
      LHLoader.ErrorSnackBar(
          title: "Error", message: "Failed to add product: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Redirect to ProductAdminView
  void _redirectToProductAdminView() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductAdminView()), // Replace with actual view
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_productImage != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        _productImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Select Product Image'),
                  onPressed: _selectImage,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryKey,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category["key"],
                      child: Text(category["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryKey = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Product Name', _productNameController),
                _buildTextField(
                    'Short Description', _productDescriptionController,
                    maxLines: 3),
                _buildTextField('Price', _productPriceController,
                    keyboardType: TextInputType.number),
                _buildTextField('Stock Quantity', _productStockController,
                    keyboardType: TextInputType.number),
                _buildTextField('Weight (kg)', _productWeightController,
                    keyboardType: TextInputType.number),
                _buildTextField(
                    'Discount Price (optional)', _productDiscountController,
                    keyboardType: TextInputType.number),
                SizedBox(height: 30),
                if (_isUploading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: Text("Add Product"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}
