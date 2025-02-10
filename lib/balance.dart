import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/pageSelection.dart';
import 'package:ecoalmaty/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BalancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BalancePageState();
  }
}

class _BalancePageState extends State<BalancePage> {
  String name = DatabaseService.userName ?? 'Загрузка';
  final SupabaseClient supabase = Supabase.instance.client;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Map<String, String>? userData;
  bool isLoading = true;

  Future<void> _loadUserData() async {
    User? user = supabase.auth.currentUser;
    if (user != null) {
      String userId = user.id;
      Map<String, String>? fetchedUser =
          await _databaseService.fetchUser(userId);
      if (mounted) {
        setState(() {
          userData = fetchedUser;
          name = fetchedUser?['name'] ?? 'Загрузка';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  // Чтобы нижний контейнер мог перекрывать верхний
                  children: [
                    Container(
                      width: AppSizes.width,
                      height: AppSizes.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/balance_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: AppSizes.width * 0.5,
                            height: AppSizes.height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/container_balance.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: AppSizes.width * 0.05,
                                height: AppSizes.height * 0.03,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/union_white.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSizes.width * 0.03),
                              Text(
                                '1 220 200',
                                style: TextStyle(
                                  fontSize: AppSizes.width * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: AppSizes.height * 0.06,
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width * 0.02,
                                    vertical: AppSizes.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '8 место',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.045),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                height: AppSizes.height * 0.06,
                                width: AppSizes.width * 0.3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width * 0.02,
                                    vertical: AppSizes.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Одно целое с \nприродой',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppSizes.width * 0.04),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: AppSizes.height * 0.55, // Поднимаем контейнер вверх
                      left: 0,
                      right: 0,
                      child: Container(
                        width: AppSizes.width,
                        height: AppSizes.height * 0.05,
                        decoration: BoxDecoration(
                          color: Color(0xFF131010),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: AppSizes.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF131010),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: AppSizes.width * 0.43,
                              height: AppSizes.height * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                // border: Border.all(
                                //   color: Color(0xFFA7EC6A), // Цвет границы
                                //   width: 2,
                                // ),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/balance_container_background.png'),
                                  // Путь к изображению
                                  fit: BoxFit
                                      .cover, // Растянуть изображение на весь контейнер
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.width * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Баланс',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.06,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Показать всю \nсумму',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppSizes.width * 0.04),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    width: AppSizes.width * 0.43,
                                    height: AppSizes.height * 0.155,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      // border: Border.all(
                                      //   color: Color(0xFFA7EC6A), // Цвет границы
                                      //   width: 2,
                                      // ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/balance_container_background2.png'),
                                        // Путь к изображению
                                        fit: BoxFit
                                            .cover, // Растянуть изображение на весь контейнер
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(AppSizes.width * 0.04),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Валюта',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.07,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Подробности',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.04),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.04,
                                ),
                                Container(
                                  width: AppSizes.width * 0.43,
                                  height: AppSizes.height * 0.155,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    // border: Border.all(
                                    //   color: Color(0xFFA7EC6A), // Цвет границы
                                    //   width: 2,
                                    // ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/balance_container_background3.png'),
                                      // Путь к изображению
                                      fit: BoxFit
                                          .cover, // Растянуть изображение на весь контейнер
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(AppSizes.width * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Магазин',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppSizes.width * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'покупка вещей за \nвнутреннюю валюту',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.03),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.02,
                        ),
                        Container(
                          width: AppSizes.width,
                          height: AppSizes.height * 0.19,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // border: Border.all(
                            //   color: Color(0xFFA7EC6A), // Цвет границы
                            //   width: 2,
                            // ),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/balance_container_background4.png'),
                              // Путь к изображению
                              fit: BoxFit
                                  .cover, // Растянуть изображение на весь контейнер
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: AppSizes.width * 0.05,
                              right: AppSizes.width * 0.05,
                              top: AppSizes.width * 0.05,
                              bottom: AppSizes.width * 0.085,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Список лучших за \nДекабрь',
                                  style: TextStyle(
                                    color: Color(0xFF004B08),
                                    fontSize: AppSizes.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Топ 100',
                                    style: TextStyle(
                                      color: Color(0xFF148305),
                                      fontSize: AppSizes.width * 0.035,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'История покупок/переводов',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.01,
                        ),
                        Container(
                          width: AppSizes.width,
                          height: AppSizes.height * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(
                  top: AppSizes.height * 0.01,
                  left: AppSizes.width * 0.03,
                  right: AppSizes.width * 0.03),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '$name',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.07),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: AppSizes.width * 0.08,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => PageSelection());
                    Navigator.pushReplacement(context, route);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
