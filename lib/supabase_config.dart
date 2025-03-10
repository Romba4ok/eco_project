import 'dart:io';
import 'package:Eco/pageSelectionAdmin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://hoyajrqksmfnocgacoxf.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhveWFqcnFrc21mbm9jZ2Fjb3hmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NTA1MTAsImV4cCI6MjA1MjQyNjUxMH0.8JxmAnPEMwMhXGCMbSBtPRW-_OfujlT7XDFF-gGstbQ'; // Замените на ваш ключ API

  static final SupabaseClient client = SupabaseClient(supabaseUrl, supabaseKey);
}

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Переменные для хранения данных
  static String? userName;
  static String? userEmail;
  static String? userCity;
  static String? userState;
  static String? userAvatar;
  static String? userPassword;
  static String? userRole;
  static int? balance;

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> logIn({
    required String email,
    required String password,
    required BuildContext context,
    required Function(int) togglePage, // Функция для смены страницы
  }) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      User? user = res.user;

      if (user != null) {
        String id = user.id;
        print("User ID: $id");

        final response = await _supabase
            .from('users')
            .select('user, name, email, state, city, avatar, balance')
            .eq('id', user.id)
            .single();
        print(response);
        if (response != null && response['user'] != null) {
          userRole = response['user'];
          userName = response['name'];
          userEmail = response['email'];
          userCity = response['city'];
          userState = response['state'];
          userPassword = response['password'];
          userAvatar = response['avatar'];
          balance = response['balance'];
          print(response['balance']);
          print("User role: $userRole");

          if (userRole == 'user') {
            togglePage(2); // Переход на страницу пользователя
          } else if (userRole == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PageSelectionAdmin()),
            ); // Переход на страницу админа
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: Роль пользователя не найдена.')),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${error.toString()}')),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String state,
    required String city,
    required BuildContext context,
    required Function(int) togglePage,
  }) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user != null) {
        String userId = res.user!.id;
        print("User registered with ID: $userId");

        await _supabase.from('users').insert({
          'id': userId,
          'name': name,
          'email': email,
          'password': password,
          'state': state,
          'city': city,
          'avatar': '',
          'user': 'user',
        });
        userRole = 'user';
        userName = name;
        userEmail = email;
        userCity = state;
        userState = city;
        userPassword = password;
        userAvatar = '';

        togglePage(2); // Переход на страницу пользователя после регистрации
      }
    } catch (error) {
      print("Registration error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${error.toString()}')),
      );
    }
  }

  Future<List<Map<String, String>>> fetchPosts() async {
    try {
      final response = await _supabase.from('posts').select();

      if (response != null && response is List) {
        return response.map((e) {
          return {
            'id': e['id'].toString(), // Преобразуем ID в строку
            'image': e['image'] as String? ?? '',
            'title': e['heading'] as String? ?? '',
            'source': e['source'] as String? ?? '',
            'content': e['content'] as String? ?? '',
          };
        }).toList();
      } else {
        print('Ошибка: Пустой ответ от Supabase');
        return [];
      }
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      return [];
    }
  }

  Future<Map<String, String>?> fetchUser(String userId) async {
    try {
      final response = await _supabase.from('users').select()
          .eq('id', userId)
          .single();

      if (response != null) {
        userRole = response['user'];
        userName = response['name'];
        userEmail = response['email'];
        userCity = response['city'];
        userState = response['state'];
        userPassword = response['password'];
        userAvatar = response['avatar'];
        balance = response['balance']; // balance остается int

        return {
          'name': response['name'] as String? ?? '',
          'id': response['id'] as String ?? '',
          'email': response['email'] as String? ?? '',
          'password': response['password'] as String? ?? '',
          'state': response['state'] as String? ?? '',
          'city': response['city'] as String? ?? '',
          'avatar': response['avatar'] as String? ?? '',
          'user': response['user'] as String? ?? '',
          'balance': response['balance'] != null ? response['balance'].toString() : '0',
        };
      } else {
        print('Ошибка: Пользователь не найден');
        return null;
      }
    } catch (e) {
      print('Ошибка при загрузке данных пользователя: $e');
      return null;
    }
  }

  Future<void> savePost(File image, String heading, String source,
      String content) async {
    try {
      // Шаг 1: Загрузка изображения в Supabase Storage
      final fileName =
          'post_images/${DateTime
          .now()
          .millisecondsSinceEpoch}.png'; // Уникальное имя файла
      await _supabase.storage
          .from('posts') // Папка "posts" в Storage
          .upload(fileName, image);

      // Шаг 2: Получение URL изображения
      final imageUrl = await _supabase.storage
          .from('posts')
          .getPublicUrl(fileName); // Получаем публичный URL изображения
      print(imageUrl);

      // Шаг 3: Добавление данных о посте в таблицу 'posts'
      await _supabase.from('posts').insert({
        'image': imageUrl,
        'heading': heading,
        'source': source,
        'content': content,
      });

      // Сообщение об успешном добавлении
      print('Пост успешно добавлен в Realtime Database!');
    } catch (error) {
      // Обработка ошибок
      print('Ошибка: $error');
    }
  }

  Future<void> updatePost({
    required int postId,
    String? newHeading,
    String? newSource,
    File? newImage,
    String? newContent,
  }) async {
    try {
      // Проверяем существование поста
      final postData = await _supabase.from('posts').select('image').eq(
          'id', postId).single();
      if (postData == null) {
        print('Ошибка: Пост не найден.');
        return;
      }

      final currentImageUrl = postData['image'] as String?;
      Map<String, dynamic> updatedData = {};

      // Обновление заголовка и источника
      if (newHeading != null && newHeading.isNotEmpty)
        updatedData['heading'] = newHeading;
      if (newSource != null && newSource.isNotEmpty)
        updatedData['source'] = newSource;
      if (newContent != null && newContent.isNotEmpty)
        updatedData['content'] = newContent;

      // Работа с изображением
      if (newImage != null) {
        // Если загружаемая картинка такая же, обновление не требуется
        if (currentImageUrl != null && currentImageUrl == newImage.path) {
          print('Изображение не изменилось, обновление не требуется.');
        } else {
          // Загружаем новое изображение перед удалением старого
          final newFileName = 'post_images/${DateTime
              .now()
              .millisecondsSinceEpoch}.png';
          final uploadResponse = await _supabase.storage.from('posts').upload(
              newFileName, newImage);

          if (uploadResponse.isEmpty) {
            throw Exception('Ошибка при загрузке нового изображения.');
          }

          // Получаем новый URL изображения
          final newImageUrl = _supabase.storage.from('posts').getPublicUrl(
              newFileName);
          updatedData['image'] = newImageUrl;

          // Удаление старого изображения
          if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
            try {
              final filePath = _getStoragePath(currentImageUrl);
              final deleteResponse = await _supabase.storage.from('posts')
                  .remove([filePath]);

              if (deleteResponse.isNotEmpty) {
                print('Старое изображение успешно удалено.');
              } else {
                print('Ошибка при удалении старого изображения.');
              }
            } catch (e) {
              print('Ошибка при удалении изображения: $e');
            }
          }
        }
      }

      // Обновление поста в базе данных
      if (updatedData.isNotEmpty) {
        await _supabase.from('posts').update(updatedData).eq('id', postId);
        print('Пост успешно обновлен.');
      } else {
        print('Нет изменений для обновления.');
      }
    } catch (e) {
      print('Ошибка при обновлении поста: $e');
    }
  }

// Вспомогательная функция для получения пути файла из URL
  String _getStoragePath(String url) {
    Uri uri = Uri.parse(url);
    return uri.path.replaceFirst('/storage/v1/object/public/posts/', '');
  }


  Future<void> updateUser({
    String? name,
    String? city,
    String? state,
    String? email,
    String? password,
    File? newAvatar,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('Ошибка: Пользователь не авторизован.');
      return;
    }

    final String userId = user.id;

    // Словарь для обновления данных в таблице "users"
    Map<String, dynamic> updatedData = {};

    if (name != null && name.isNotEmpty) updatedData['name'] = name;
    if (city != null && city.isNotEmpty) updatedData['city'] = city;
    if (state != null && state.isNotEmpty) updatedData['state'] = state;
    if (email != null && email.isNotEmpty) updatedData['email'] = email;

    try {
      // Обновление пароля в Auth
      if (password != null && password.isNotEmpty) {
        await _supabase.auth.updateUser(UserAttributes(password: password));
        await _supabase.from('users').update({'password': password}).eq(
            'id', userId);
        print('Пароль успешно обновлен.');
      }
      print('Пароль успешно обновлен в базе данных.');

      // Работа с аватаркой
      if (newAvatar != null) {
        // Получаем текущий URL аватарки из Realtime Database
        final userData = await _supabase.from('users').select('avatar').eq(
            'id', userId).single();
        final currentAvatar = userData['avatar'] as String?;

        // Если новая аватарка совпадает с текущей, обновление не требуется
        if (currentAvatar != null && currentAvatar == newAvatar.path) {
          print('Аватарка не изменилась, обновление не требуется.');
          return;
        }

        // Загрузка новой аватарки перед удалением старой
        final newFileName = 'avatars_images/${DateTime
            .now()
            .millisecondsSinceEpoch}.png';
        final uploadResponse = await _supabase.storage.from('avatars').upload(
            newFileName, newAvatar);

        if (uploadResponse.isEmpty) {
          throw Exception('Ошибка при загрузке новой аватарки.');
        }

        // Получаем публичный URL новой аватарки
        final newAvatarUrl = _supabase.storage.from('avatars').getPublicUrl(
            newFileName);

        // Удаление старой аватарки (если она существует)
        if (currentAvatar != null && currentAvatar.isNotEmpty) {
          try {
            final uri = Uri.parse(currentAvatar);
            final filePath = uri.path.replaceFirst(
                '/storage/v1/object/public/avatars/', '');


            print('Удаление старой аватарки: $filePath');

            final deleteResponse = await _supabase.storage.from('avatars')
                .remove([filePath]);

            if (deleteResponse.isNotEmpty) {
              print('Старая аватарка успешно удалена.');
            } else {
              print('Ошибка: файл не найден или не удалось удалить.');
            }
          } catch (e) {
            print('Ошибка при удалении старой аватарки: $e');
          }
        }

        // Обновляем ссылку на новую аватарку в Realtime Database
        await _supabase.from('users').update({'avatar': newAvatarUrl}).eq(
            'id', userId);

        print('Аватарка успешно обновлена.');
      }
    } catch (e) {
      print('Ошибка при обновлении пользователя: $e');
    }
  }

  Future<void> deletePost(int postId, String imageUrl) async {
    try {
      // Шаг 1: Получаем путь к файлу в Supabase Storage
      final String filePath = _getStoragePath(imageUrl);
      await _supabase.storage.from('posts').remove([filePath]);
      await _supabase.from('posts').delete().eq('id', postId);
    } catch (error) {
      print('Ошибка при удалении поста: $error');
    }
  }

}
