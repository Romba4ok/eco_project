import 'package:Eco/appSizes.dart';
import 'package:Eco/shop.dart';
import 'package:Eco/training_shop1.dart';
import 'package:flutter/material.dart';

class TrainingShop2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrainingShop1State();
  }
}

class _TrainingShop1State extends State<TrainingShop2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: AppSizes.width,
              height: AppSizes.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  AssetImage('assets/images/background_training_shop2.png'),
                  // Путь к изображению
                  fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AppSizes.height * 0.2,
                  ),
                  Container(
                    width: AppSizes.width,
                    height: AppSizes.height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/container_training_shop2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.08,
                  ),
                  Container(
                    width: AppSizes.width * 0.04,
                    height: AppSizes.width * 0.035,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/page_2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.02,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.width * 0.15),
                    child: Text(
                      'С помощью нашей внутренней валюты EcoCoin вы можете обменивать накопленные средства на стильную брендированную одежду.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.05,
                  ),
                  Container(
                    width: AppSizes.width * 0.5,
                    height: AppSizes.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xFF95D565),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopPage()),
                        );
                      },
                      child: Text(
                        'Далее',
                        style: TextStyle(
                            fontSize: AppSizes.width * 0.06,
                            color: Color(0xFF153100)),
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
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: AppSizes.width * 0.08,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => TrainingShop1());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}