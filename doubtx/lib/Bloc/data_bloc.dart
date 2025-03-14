import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DataCubit extends Cubit<Map<String, dynamic>> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  final String _storageKey = "UserDataMap";

  DataCubit() : super({}) {
    _loadData();
  }

  /// Load data from Secure Storage
  Future<void> _loadData() async {
    String? storedData = await _storage.read(key: _storageKey);
    if (storedData != null) {
      emit(jsonDecode(storedData)); // Update state with saved user data
    }else{
      emit({});
    }
  }

  /// Update data and save globally
  Future<void> updateData(Map<String, dynamic> newData) async {
    await _storage.write(key: _storageKey, value: jsonEncode(newData));
    emit(newData); // Update state
  }

  /// Logout
  Future<void> signOut() async {
    await _storage.deleteAll();
    emit({}); // Update state
  }
}
