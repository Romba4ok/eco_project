import 'package:Eco/appSizes.dart';
import 'package:Eco/balance.dart';
import 'package:flutter/material.dart';

class CurrencyInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CurrencyInfoState();
  }
}

class _CurrencyInfoState extends State<CurrencyInfo> {
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
                  image: AssetImage('assets/images/currency_background.png'),
                  // Путь к изображению
                  fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                ),
              ),
              child: Center(
                child: Container(
                  width: AppSizes.width * 0.85,
                  height: AppSizes.height * 0.75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xFF131010)),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.width * 0.05),
                    child: Column(
                      children: [
                        Container(
                          width: AppSizes.width * 0.4,
                          height: AppSizes.height * 0.245,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/coin_currency.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'Уникальная внутренняя валюта — ECOCOIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.height * 0.02,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Как использовать ECOCOIN:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.height * 0.005,),
                        Text(
                          '1 Покупка  уникального мерча! Вы можете приобретать стильные и уникальные вещи, подчеркивая свою индивидуальность.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: AppSizes.height * 0.02,),
                        Text(
                          '2 Обмен на реальные деньги. Заработанные ЭкоКоины можно вывести, чтобы использовать их в повседневной жизни.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: AppSizes.height * 0.02,),
                        Text(
                          '3 Поддержка экологии. Часть средств, связанных с использованием ЭкоКоинов, направляется на проекты, связанные с защитой окружающей среды, восстановлением лесов и сокращением углеродного следа.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: AppSizes.height * 0.02,),
                        Text(
                          'ECOCOIN не просто способ сделать покупки или обменивать валюту. Это ваш вклад в улучшение экологии и заботу о будущем нашей планеты.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
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
                          builder: (context) => BalancePage());
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
