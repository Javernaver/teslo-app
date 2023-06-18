import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

var logger = Logger();

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      logger.i(response.data);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token no es valido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      logger.e('Error en la petición');

      throw CustomError('Error desconocido');
    } catch (e) {
      throw CustomError('Error desconocido');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      logger.i(response.data);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales no validas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      logger.e('Error en la petición');

      throw CustomError('Error desconocido');
    } catch (e) {
      throw CustomError('Error desconocido');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
