import 'package:Eco/appSizes.dart';
import 'package:Eco/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  final supabase = Supabase.instance.client;
  List<CustomUser> users = [];
  String searchQuery = "";
  bool isLoading = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final data = await supabase
          .from('users') // Таблица в Supabase
          .select(
              'id, name, state, city, email, avatar, user, password'); // Поля из таблицы

      setState(() {
        users = (data as List<dynamic>)
            .map((user) => CustomUser(
                  id: user['id'],
                  name: user['name'],
                  state: user['state'],
                  city: user['city'],
                  email: user['email'],
                  password: user['password'],
                  avatar: user['avatar'] ?? '',
                  user_user: user['user'],
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки пользователей: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CustomUser> filteredUsers = users.where((user) {
      String lowerQuery = searchQuery.toLowerCase();
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.state.toLowerCase().contains(lowerQuery) ||
          user.city.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery) ||
          user.id.toLowerCase().contains(lowerQuery);
    }).toList();

    // Сортируем по количеству совпадений
    filteredUsers.sort((a, b) {
      int aMatches = _countMatches(a, searchQuery);
      int bMatches = _countMatches(b, searchQuery);
      return bMatches.compareTo(aMatches); // Убывающая сортировка
    });
    return Scaffold(
      backgroundColor: Color(0xFF131010),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.height * 0.1,
            ),
            Row(
              children: [
                Icon(Icons.group, color: Color(0xFFA3E567)),
                SizedBox(width: AppSizes.width * 0.02),
                Text('Список пользователей',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppSizes.width * 0.06)),
              ],
            ),
            SizedBox(
              height: AppSizes.height * 0.01,
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFF9A9A9A)),
                hintText: 'Поиск',
                hintStyle: TextStyle(
                    color: Color(
                      0xFF9A9A9A,
                    ),
                    fontSize: AppSizes.width * 0.04),
                filled: true,
                fillColor: Color(0xFF2B2B2B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Container(
                    child: Column(
                      children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: AppSizes.width * 0.05,
                              backgroundImage: user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
                              backgroundColor: user.avatar.isEmpty ? Colors.white : Colors.transparent,
                              child: user.avatar.isEmpty
                                  ? Text(
                                user.name[0],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppSizes.width * 0.07,
                                ),
                              )
                                  : null,
                            ),
                            SizedBox(
                              width: AppSizes.width * 0.01,
                            ),
                            Container(
                              width: AppSizes.width * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.id,
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: AppSizes.width * 0.25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.state}, ${user.city}',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                emailController.text = user.email;
                                passwordController.text = user.password;

                                String? emailValidator(String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите email';
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Неверный формат email';
                                  }
                                  return null;
                                }

                                String? passwordValidator(String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите пароль';
                                  }
                                  if (value.length < 8) {
                                    return 'Пароль должен содержать не менее 8 символов';
                                  }
                                  return null;
                                }

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Color(0xFF2B2B2B),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            AppSizes.width * 0.03),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
                                                    backgroundColor: user.avatar.isEmpty ? Colors.white : Colors.transparent,
                                                    child: user.avatar.isEmpty
                                                        ? Text(
                                                      user.name[0],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: AppSizes.width * 0.07,
                                                      ),
                                                    )
                                                        : null,
                                                  ),
                                                  SizedBox(
                                                      width: AppSizes.width *
                                                          0.02),
                                                  Text(
                                                    user.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                      width: AppSizes.width *
                                                          0.02),
                                                  SizedBox(
                                                    width:
                                                        AppSizes.width * 0.45,
                                                    // Установите ширину в пикселях
                                                    child: Text(
                                                      'id: ${user.id}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      AppSizes.height * 0.02),
                                              TextFormField(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xFF262323),
                                                  labelText: "Email",
                                                  labelStyle: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                  hintText: "example@gmail.com",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    // Цвет границы при ошибке
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    // Граница при фокусе и ошибке
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                validator: emailValidator,
                                              ),
                                              SizedBox(
                                                height: AppSizes.height * 0.01,
                                              ),
                                              TextFormField(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: passwordController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xFF262323),
                                                  labelText: "Пароль",
                                                  labelStyle: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                  hintText: "Введите пароль",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    // Цвет границы при ошибке
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    // Граница при фокусе и ошибке
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                validator: passwordValidator,
                                              ),
                                              SizedBox(
                                                  height:
                                                      AppSizes.height * 0.02),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFA3E567),
                                                    ),
                                                    onPressed: () async {
                                                      if (_formKey.currentState!.validate()) {
                                                        try {
                                                          // Обновление данных пользователя в Supabase Authentication
                                                          final authResponse = await supabase.auth.updateUser(
                                                            UserAttributes(
                                                              email: emailController.text,
                                                              password: passwordController.text,
                                                            ),
                                                          );

                                                          if (authResponse.user != null) {
                                                            // Получаем ID пользователя из ответа
                                                            final userId = authResponse.user!.id;
                                                            print('userId: $userId'); // Для отладки

                                                            // Обновление данных в таблице 'users'
                                                            try {
                                                              await Supabase.instance.client
                                                                  .from('users')
                                                                  .update({'password': passwordController.text}).eq('id', userId);
                                                              Navigator.of(context)
                                                                  .pop();
                                                              fetchUsers();
                                                            } catch (error) {
                                                              print(error);
                                                            }
                                                          } else {
                                                            // Ошибка при обновлении данных в Supabase Authentication
                                                            throw 'Ошибка обновления данных пользователя в Authentication';
                                                          }
                                                        } catch (error) {
                                                          // Общий обработчик ошибок
                                                          print('Произошла ошибка: $error');
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Произошла ошибка: $error'),
                                                              backgroundColor: Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Text('Сохранить'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Закрыть диалог
                                                    },
                                                    child: Text('Отмена',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.settings,
                                color: Color(0xFFA3E567),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _countMatches(CustomUser user, String query) {
    if (query.isEmpty) return 0;
    String lowerQuery = query.toLowerCase();
    int matches = 0;
    if (user.name.toLowerCase().contains(lowerQuery)) matches++;
    if (user.state.toLowerCase().contains(lowerQuery)) matches++;
    if (user.city.toLowerCase().contains(lowerQuery)) matches++;
    if (user.email.toLowerCase().contains(lowerQuery)) matches++;
    if (user.id.toLowerCase().contains(lowerQuery)) matches++;
    return matches;
  }
}
