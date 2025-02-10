import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/balance.dart';
import 'package:ecoalmaty/info.dart';
import 'package:ecoalmaty/permission.dart';
import 'package:ecoalmaty/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final Function(int) togglePage;
  HomePage({required this.togglePage});
  @override
  State<StatefulWidget> createState() {
    return _StateHomePage();
  }
}

class _StateHomePage extends State<HomePage> {
  final AppPermission appPermission = AppPermission();

  final SupabaseClient supabase = Supabase.instance.client;

  // Список для хранения постов
  List<Map<String, String>> posts = [];
  bool isLoading = true;

  final DatabaseService _databaseService = DatabaseService();

  Future<void> loadPosts() async {
    List<Map<String, String>> fetchedPosts =
        await _databaseService.fetchPosts();
    if (mounted) {
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    }
  }

  Future<void> handlePermissionCheck() async {
    await AppPermission.checkAndRequestLocationPermission();
  }

  @override
  void initState() {
    super.initState();
    handlePermissionCheck();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.width,
                  height: AppSizes.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background_home.png'),
                      // Путь к изображению
                      fit: BoxFit
                          .cover, // Растянуть изображение на весь контейнер
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: AppSizes.width * 0.05,
                        right: AppSizes.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Ты можешь помочь улучшить экологию!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.08),
                          softWrap: true,
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.02,
                        ),
                        Text(
                          'Маленькие шаги каждого из нас могут привести к большим переменам.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.05),
                          softWrap: true,
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.02,
                        ),
                        Container(
                          width: AppSizes.width * 0.3,
                          height: AppSizes.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Color(0xFF95D565),
                          ),
                          child: TextButton(
                              onPressed: () {
                                User? user = supabase.auth.currentUser;
                                if (user != null) {
                                  Route route = MaterialPageRoute(builder: (context) => BalancePage());
                                  Navigator.pushReplacement(context, route);
                                } else {
                                  print('Передача в togglePage(1)');  // Проверка
                                  widget.togglePage(1);
                                }
                              },
                              child: Text(
                                'Начать',
                                style: TextStyle(
                                    fontSize: AppSizes.width * 0.06,
                                    color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.08,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppSizes.width * 0.1),
                  child: Text(
                    'ЛЕНТА НОВОСТЕЙ',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppSizes.width * 0.045),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.03,
                ),
                isLoading
                    ? SizedBox(
                        height: AppSizes.height * 0.8,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        height: AppSizes.height * 0.8, // Высота GridView
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width * 0.02),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Две колонки
                            mainAxisSpacing: 8, // Отступ между рядами
                            crossAxisSpacing: 8, // Отступ между колонками
                            childAspectRatio:
                                3 / 4, // Соотношение сторон карточки
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return GestureDetector(
                              onTap: () {
                                print('Tapped on: ${post['title']}');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black, // Черный фон карточки
                                  borderRadius: BorderRadius.circular(
                                      12), // Закругленные углы
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                          // Закругленные углы внизу
                                          bottomRight: Radius.circular(12),
                                        ),
                                        child: SizedBox(
                                          width: AppSizes.width * 0.45,
                                          // Ширина изображения
                                          child: Image.network(
                                            post['image']!,
                                            fit: BoxFit
                                                .cover, // Заполняет контейнер, обрезая края
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSizes.height * 0.005,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: AppSizes.width * 0.02,
                                          right: AppSizes.width * 0.02),
                                      child: Text(
                                        post['title']!,
                                        style: TextStyle(
                                          fontSize: AppSizes.width * 0.05,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSizes.height * 0.005,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppSizes.width * 0.02),
                                      child: Text(
                                        post['source']!,
                                        style: TextStyle(
                                          fontSize: AppSizes.width * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          // AppBar должен быть сверху и фиксированным
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.height * 0.08, // Отступ сверху
                  right: AppSizes.width * 0.05, // Отступ справа
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Первый контейнер с иконкой
                      Container(
                        height: AppSizes.height * 0.055,
                        width: AppSizes.width * 0.125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF303030),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.assignment,
                              size: AppSizes.height * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.width * 0.03),
                      // Второй контейнер с иконкой
                      Container(
                        height: AppSizes.height * 0.055,
                        width: AppSizes.width * 0.125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF303030),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                builder: (context) => PageInfo(),
                              );
                              Navigator.push(context, route);
                            },
                            icon: Icon(
                              Icons.apps,
                              size: AppSizes.height * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
