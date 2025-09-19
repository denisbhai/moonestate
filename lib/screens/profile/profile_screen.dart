import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedGender = '';
  String imageUrl = '';
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _usernameController.text = user.username;
      _phoneController.text = user.phone;
      _descriptionController.text = user.description;
      _dateController.text = user.dateOfBirth.toLocal().toString().split(
        ' ',
      )[0];
      _selectedGender = user.gender;
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user!;

      final updatedUser = User(
        id: user.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: user.email,
        phone: _phoneController.text,
        description: _descriptionController.text,
        dateOfBirth: DateTime.parse(_dateController.text),
        gender: _selectedGender,
        avatar: user.avatar,
      );

      await authProvider.updateUserProfile(updatedUser, file: image);

      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    }
  }

  File? image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_dateController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
    LanguageProvider languageProvide,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(languageProvide.translate('logout')),
          content: Text(languageProvide.translate('logoutText')),
          actions: [
            TextButton(
              child: Text(languageProvide.translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff08184B),
              ),
              child: Text(
                languageProvide.translate('logout'),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Center(child: Text('User not found'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          languageProvider.translate('profile'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(icon: Icon(Icons.save_as), onPressed: _updateProfile),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _loadUserData(); // Reset form
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture
                    Center(
                      child: GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: image != null
                                ? Image.file(image!)
                                : user.avatar.isNotEmpty
                                ? Image.network(user.avatar)
                                : Icon(Icons.person, size: 50),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!_isEditing)
                      Text(
                        "${_firstNameController.text} ${_lastNameController.text}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (!_isEditing) SizedBox(height: 5),
                    if (!_isEditing)
                      Text(
                        "${_phoneController.text}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8D8D8D),
                        ),
                      ),

                    // First Name
                    _isEditing
                        ? TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate(
                                'first_name',
                              ),
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return languageProvider.translate(
                                  'please_enter_first_name',
                                );
                              }
                              return null;
                            },
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Last Name
                    _isEditing
                        ? TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate(
                                'last_name',
                              ),
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return languageProvider.translate(
                                  'please_enter_last_name',
                                );
                              }
                              return null;
                            },
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Username
                    _isEditing
                        ? TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate('username'),
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return languageProvider.translate(
                                  'please_enter_username',
                                );
                              }
                              return null;
                            },
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Phone
                    _isEditing
                        ? TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate('phone'),
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Description
                    _isEditing
                        ? TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate(
                                'description',
                              ),
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            maxLines: 3,
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Date of Birth
                    _isEditing
                        ? TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate(
                                'date_of_birth',
                              ),
                              border: OutlineInputBorder(),
                              suffixIcon: _isEditing
                                  ? Icon(Icons.calendar_today)
                                  : null,
                            ),
                            enabled: _isEditing,
                            onTap: _isEditing ? _selectDate : null,
                          )
                        : SizedBox(),
                    _isEditing ? SizedBox(height: 16) : SizedBox(),

                    // Gender
                    _isEditing
                        ? DropdownButtonFormField<String>(
                            value: _selectedGender.isNotEmpty
                                ? _selectedGender
                                : null,
                            decoration: InputDecoration(
                              labelText: languageProvider.translate('gender'),
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text(languageProvider.translate('male')),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(
                                  languageProvider.translate('female'),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'other',
                                child: Text(
                                  languageProvider.translate('other'),
                                ),
                              ),
                            ],
                            onChanged: _isEditing
                                ? (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  }
                                : null,
                          )
                        : SizedBox(),
                    SizedBox(height: 24),

                    // Logout Button
                    if (!_isEditing)
                      GestureDetector(
                        onTap: () async {
                          _showLogoutDialog(
                            context,
                            authProvider,
                            languageProvider,
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.logout, size: 30),
                            SizedBox(width: 10),
                            Text(
                              languageProvider.translate('logout'),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 10),
                    if (!_isEditing)
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.settings_outlined, size: 30),
                          SizedBox(width: 10),
                          Text(
                            languageProvider.translate('settings'),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    if (!_isEditing)
                      GestureDetector(
                        onTap: () {
                          _showLanguageDialog();
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.language, size: 30),
                            SizedBox(width: 10),
                            Text(
                              languageProvider.translate('language'),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showLanguageDialog() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languageProvider.translate('select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.language, color: Colors.blue),
                title: Text('English'),
                trailing: languageProvider.currentLocale.languageCode == 'en'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  languageProvider.changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.language, color: Colors.orange),
                title: Text('हिंदी (Hindi)'),
                trailing: languageProvider.currentLocale.languageCode == 'hi'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  languageProvider.changeLanguage('hi');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
