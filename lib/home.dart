import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/geolocation.dart';
import 'package:ecoalmaty/info.dart';
import 'package:ecoalmaty/permission.dart';
import 'package:ecoalmaty/requestcheck.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StateHomePage();
  }
}

class _StateHomePage extends State<HomePage> {
  final AppPermission appPermission = AppPermission();
  Future<void> handlePermissionCheck() async {
    await AppPermission.checkAndRequestLocationPermission();
  }
  @override
  void initState() {
    super.initState();
    handlePermissionCheck();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
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
                                onPressed: () {},
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
                    child: Text('ЛЕНТА НОВОСТЕЙ', style: TextStyle(color: Colors.white, fontSize: AppSizes.width * 0.04),),
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.4,
                  ),
                ],
              ),
            ],
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
                            onPressed: () {
                            },
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
                              Route route = MaterialPageRoute(builder: (context) => PageInfo(),);
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
