import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis_buddy_flutter/api_service.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(155, 2, 30, 52),
      appBar: AppBar(
        title: const Text(
          "TENNIS BUDDY",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(52.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 4.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: const RegistrationForm(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _playHandController = TextEditingController();

  List<dynamic> _countries = [];
  List<dynamic> _states = [];
  List<dynamic> _cities = [];

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      List<Map<String, dynamic>> countries = await _apiService.fetchCountries();
      setState(() {
        _countries = countries;
      });
    } catch (error) {
      log('Error fetching countries: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching countries: $error')),
      );
    }
  }

  Future<void> _fetchStates(String countryId) async {
    try {
      List<Map<String, dynamic>> states =
          await _apiService.fetchStates(countryId);
      setState(() {
        _states = states;
        _selectedState = null;
        _selectedCity = null;
        _cities = [];
      });
    } catch (error) {
      log('Error fetching states: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching states: $error')),
      );
    }
  }

  Future<void> _fetchCities(String countryId, String stateId) async {
    try {
      List<Map<String, dynamic>> cities =
          await _apiService.fetchCities(countryId, stateId);
      setState(() {
        _cities = cities;
        _selectedCity = null;
      });
    } catch (error) {
      log('Error fetching cities: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching cities: $error')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _pincodeController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _playHandController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _apiService
          .registerUser(
        _nameController.text,
        _mobileController.text,
        _emailController.text,
        _selectedCountry!,
        _selectedState!,
        _selectedCity!,
        _pincodeController.text,
        _passwordController.text,
        _birthDateController.text,
        _playHandController.text,
      )
          .then((response) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
      }).catchError((e) {
        print('Error registering user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering user: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/cricket.jpg',
                scale: 1.8,
              ),
              const Text(
                'REGISTRATION',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Country'),
                  value: _selectedCountry,
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country['id'].toString(),
                      child: Text(country['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value as String?;
                      _selectedState = null;
                      _selectedCity = null;
                      _states = [];
                      _cities = [];
                      if (_selectedCountry != null) {
                        _fetchStates(_selectedCountry!);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your country';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'State'),
                  value: _selectedState,
                  items: _states.map((state) {
                    return DropdownMenuItem(
                      value: state['id'].toString(),
                      child: Text(state['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value as String?;
                      _selectedCity = null;
                      _cities = [];
                      if (_selectedState != null && _selectedCountry != null) {
                        _fetchCities(_selectedCountry!, _selectedState!);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your state';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  value: _selectedCity,
                  items: _cities.map((city) {
                    return DropdownMenuItem(
                      value: city['id'].toString(),
                      child: Text(city['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pincode';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birth date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _playHandController,
                  decoration: const InputDecoration(labelText: 'Play Hand'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your play hand';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _submitForm();
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
