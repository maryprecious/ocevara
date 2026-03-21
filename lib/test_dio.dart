import 'package:dio/dio.dart';

void main() async {
    // final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3001/fish'));
  final dio = Dio(BaseOptions(baseUrl: 'https://ocevara-teiw.onrender.com/fish'));
  
  // path starts with /
  print('Path starts with /: ${Uri.parse(dio.options.baseUrl).resolve('/auth/login')}');
  
  // path doesn\'t start with /
  print('Path doesn\'t start with /: ${Uri.parse(dio.options.baseUrl).resolve('auth/login')}');
  
  //  final dioWithSlash = Dio(BaseOptions(baseUrl: 'http://localhost:3001/fish/'));
  final dioWithSlash = Dio(BaseOptions(baseUrl: 'https://ocevara-teiw.onrender.com/fish/'));
  print('Base with /, paths starts with /: ${Uri.parse(dioWithSlash.options.baseUrl).resolve('/auth/login')}');
  print('Base with /, path doesn\'t start with /: ${Uri.parse(dioWithSlash.options.baseUrl).resolve('auth/login')}');
}
