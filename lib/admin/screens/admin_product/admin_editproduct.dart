import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lhstore/utils/helpers/customSnakbar.dart';

class EditProductAdmin extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> initialData;

  const EditProductAdmin({
    Key? key,
    required this.productId,
    required this.initialData,
  }) : super(key: key);

  @override
  _EditProductAdminState createState() => _EditProductAdminState();
}

class _EditProductAdminState extends State<EditProductAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productWeightController = TextEditingController();
  final TextEditingController _productDiscountController = TextEditingController();

  Uint8List? _productImage;
  String? _existingImageUrl;
  String? _selectedCategoryKey;
  List<Map<String, dynamic>> _categories = [];
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _fetchCategories();
  }

  void _initializeForm() {
    _productNameController.text = widget.initialData["name"];
    _productDescriptionController.text = widget.initialData["description"];
    _productPriceController.text = widget.initialData["price"].toString();
    _productStockController.text = widget.initialData["stock"].toString();
    _productWeightController.text = widget.initialData["weight"].toString();
    _productDiscountController.text = widget.initialData["discount"].toString();
    _existingImageUrl = widget.initialData["imageUrl"];
    _selectedCategoryKey = widget.initialData["categoryKey"];
  }

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
      LHLoader.ErrorSnackBar(title: "Error", message: "Failed to fetch categories: $e");
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _productImage = imageBytes; // Set new image
      });
    }
  }

  Future<String?> _uploadImageToImgBB() async {
    if (_productImage == null) return _existingImageUrl;

    const String apiKey = "1a17fbc4c53e8e20d5502fe02bf707dd";
    final url = Uri.parse("https://api.imgbb.com/1/upload");

    try {
      final response = await http.post(
        url,
        body: {
          "key": apiKey,
          "image": base64Encode(_productImage!),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]["url"];
      } else {
        LHLoader.ErrorSnackBar(title: "Error", message: "Image upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      LHLoader.ErrorSnackBar(title: "Error", message: "Failed to upload image: $e");
      return null;
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
    });

    final imageUrl = await _uploadImageToImgBB();

    if (imageUrl == null) {
      setState(() {
        _isUpdating = false;
      });
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref("Products").child(widget.productId);
    try {
      await dbRef.update({
        "name": _productNameController.text,
        "description": _productDescriptionController.text,
        "price": double.parse(_productPriceController.text),
        "stock": int.parse(_productStockController.text),
        "weight": double.parse(_productWeightController.text),
        "discount": double.parse(_productDiscountController.text.isNotEmpty ? _productDiscountController.text : "0"),
        "category": _categories.firstWhere((category) => category["key"] == _selectedCategoryKey)["name"],
        "categoryKey": _selectedCategoryKey,
        "imageUrl": imageUrl,
      });

      LHLoader.successSnackBar(title: "Success", message: "Product updated successfully");
      Navigator.pop(context);
    } catch (e) {
      LHLoader.ErrorSnackBar(title: "Error", message: "Failed to update product: $e");
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
                if (_productImage != null || _existingImageUrl != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _productImage != null
                          ? Image.memory(
                              _productImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _existingImageUrl!,
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
                _buildTextField('Short Description', _productDescriptionController, maxLines: 3),
                _buildTextField('Price', _productPriceController, keyboardType: TextInputType.number),
                _buildTextField('Stock Quantity', _productStockController, keyboardType: TextInputType.number),
                _buildTextField('Weight (kg)', _productWeightController, keyboardType: TextInputType.number),
                _buildTextField('Discount Price (optional)', _productDiscountController, keyboardType: TextInputType.number),
                SizedBox(height: 30),
                if (_isUpdating)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _updateProduct,
                    child: Text("Update Product"),
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
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }
}
