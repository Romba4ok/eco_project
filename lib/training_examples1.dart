import 'package:Eco/appSizes.dart';
import 'package:Eco/training_examples2.dart';
import 'package:flutter/material.dart';

class TrainingExamples1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrainingExamples1State();
  }
}

class _TrainingExamples1State extends State<TrainingExamples1> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: AppSizes.width,
          height: AppSizes.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/background_training_examples1.png'),
              // Путь к изображению
              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSizes.height * 0.1,
                ),
                Text(
                  'Просим заметить',
                  style: TextStyle(
                    color: Color(0xFF79FF00),
                    fontSize: AppSizes.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.01,
                ),
                Container(
                  width: AppSizes.width * 0.55,
                  child: Text(
                    'Каждый день мы сталкиваемся с сотнями потоков информации, но часто упускаем из виду главную проблему, находящуюся прямо перед нами.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.58,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: AppSizes.width * 0.6,
                      child: Text(
                        'Мы не призываем и не вынуждаем вас следовать нашим рекомендациям. Все действия остаются исключительно на ваше усмотрение и выполняются по вашему собственному желанию.',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: AppSizes.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: AppSizes.width * 0.15,
                      height: AppSizes.width * 0.15,
                      decoration: BoxDecoration(
                        color: Color(0xFF2E2E2E), // Тёмно-серый фон контейнера
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(builder: (context) => TrainingExamples2());
                          Navigator.pushReplacement(context, route);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.green, // Зелёная стрелка
                          size: AppSizes.width * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
