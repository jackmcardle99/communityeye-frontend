/*
File: profile_viewmodel.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final AuthProvider _authProvider;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  ProfileViewModel(this._userRepository, this._authProvider);

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _user = await _userRepository.fetchUserProfile();
    if (_user == null) {
      _errorMessage = 'Failed to fetch user data';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(
  String? firstName,
  String? lastName,
  String? emailAddress,
  String? mobileNumber,
  String? city,
  String? password,
) async {
  if (_user == null) return false;

  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  final Map<String, dynamic> updatedData = {};

  if (firstName != null && firstName != _user?.firstName) {
    updatedData['first_name'] = firstName;
  }
  if (lastName != null && lastName != _user?.lastName) {
    updatedData['last_name'] = lastName;
  }
  if (emailAddress != null && emailAddress != _user?.email) {
    updatedData['email_address'] = emailAddress;
  }
  if (mobileNumber != null && mobileNumber != _user?.mobileNumber) {
    updatedData['mobile_number'] = mobileNumber;
  }
  if (city != null && city != _user?.city) {
    updatedData['city'] = city;
  }
  if (password != null && password.isNotEmpty) {
    updatedData['password'] = password;
  }

  if (updatedData.isEmpty) {
    _isLoading = false;
    notifyListeners();
    return false;
  }

  bool success = await _userRepository.updateUserProfile(updatedData);

  if (success) {
    _user = _user!.copyWith(
      firstName: firstName ?? _user?.firstName,
      lastName: lastName ?? _user?.lastName,
      email: emailAddress ?? _user?.email,
      mobileNumber: mobileNumber ?? _user?.mobileNumber,
      city: city ?? _user?.city,
    );
  } else {
    _errorMessage = 'Failed to update profile';
  }

  _isLoading = false;
  notifyListeners();
  return success;
}

  Future<void> logout() async {
    await _authProvider.logout();
  }

  Future<void> deleteUserAccount() async {
    await _authProvider.deleteUserAccount();
  }
}
