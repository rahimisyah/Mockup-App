// lib/screens/address_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Address {
  final String type; // 'primary' or 'secondary'
  final String addressLine;
  final String road;
  final String postcode;
  final String city;

  Address({
    required this.type,
    required this.addressLine,
    required this.road,
    required this.postcode,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      type: json['type'],
      addressLine: json['addressLine'],
      road: json['road'],
      postcode: json['postcode'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'addressLine': addressLine,
      'road': road,
      'postcode': postcode,
      'city': city,
    };
  }

  String get displayTitle {
    return type == 'primary' ? 'Primary Address' : 'Secondary Address';
  }
}

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> _addresses = [];
  bool _isEditing = false;
  Address? _editingAddress;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  late TextEditingController _roadController;
  late TextEditingController _postcodeController;
  late TextEditingController _cityController;
  String _addressType = 'primary'; // 'primary' or 'secondary'

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _roadController = TextEditingController();
    _postcodeController = TextEditingController();
    _cityController = TextEditingController();
    _loadAddresses();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _roadController.dispose();
    _postcodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final primaryJson = prefs.getString('address_primary');
    final secondaryJson = prefs.getString('address_secondary');

    final addresses = <Address>[];

    if (primaryJson != null) {
      final data = jsonDecode(primaryJson);
      addresses.add(Address.fromJson(data));
    }

    if (secondaryJson != null) {
      final data = jsonDecode(secondaryJson);
      addresses.add(Address.fromJson(data));
    }

    setState(() {
      _addresses = addresses;
    });
  }

  Future<void> _saveAddress(Address address) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(address.toJson());
    if (address.type == 'primary') {
      await prefs.setString('address_primary', json);
    } else {
      await prefs.setString('address_secondary', json);
    }
    _loadAddresses(); // Refresh list
  }

  Future<void> _deleteAddress(String type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == 'primary') {
      await prefs.remove('address_primary');
    } else {
      await prefs.remove('address_secondary');
    }
    _loadAddresses();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${type == 'primary' ? 'Primary' : 'Secondary'} address deleted")),
    );
  }

  void _startEditing(Address? address) {
    setState(() {
      _isEditing = true;
      _editingAddress = address;
      _addressType = address?.type ?? 'primary';

      if (address != null) {
        _addressController.text = address.addressLine;
        _roadController.text = address.road;
        _postcodeController.text = address.postcode;
        _cityController.text = address.city;
      } else {
        _addressController.clear();
        _roadController.clear();
        _postcodeController.clear();
        _cityController.clear();
      }
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        type: _addressType,
        addressLine: _addressController.text,
        road: _roadController.text,
        postcode: _postcodeController.text,
        city: _cityController.text,
      );
      await _saveAddress(address);
      setState(() {
        _isEditing = false;
        _editingAddress = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address saved!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Address" : "Manage Addresses"),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _editingAddress = null;
                });
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _isEditing
          ? _buildEditForm()
          : _buildAddressList(),
    );
  }

  Widget _buildAddressList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Saved Addresses",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (_addresses.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No addresses saved yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ..._addresses.map((address) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address.displayTitle,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => _startEditing(address),
                              child: Text("Edit", style: TextStyle(color: Colors.blue)),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Delete Address"),
                                    content: Text("Are you sure you want to delete this ${address.displayTitle.toLowerCase()}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          _deleteAddress(address.type);
                                        },
                                        child: Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(address.addressLine),
                    Text(address.road),
                    Text("${address.postcode}, ${address.city}"),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _startEditing(null),
            icon: Icon(Icons.add),
            label: Text("Add New Address"),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: _addressType,
              decoration: InputDecoration(labelText: "Select Type"),
              items: [
                DropdownMenuItem(value: 'primary', child: Text("Primary Address")),
                DropdownMenuItem(value: 'secondary', child: Text("Secondary Address")),
              ],
              onChanged: (value) {
                setState(() {
                  _addressType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Address Line 1", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _roadController,
              decoration: InputDecoration(labelText: "Road / Street", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _postcodeController,
              decoration: InputDecoration(labelText: "Postcode", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: "City", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveForm,
                child: Text(_editingAddress != null ? "Update Address" : "Save Address"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}