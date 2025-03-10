import 'package:Eco/appSizes.dart';
import 'package:Eco/balance.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopPageState();
  }
}

class _TopPageState extends State<TopPage> {
  final int defaultVisibleUsers = 15;
  final List<Map<String, dynamic>> users = [
    {
      "rank": 1,
      "name": "Machinegunkelly69",
      "score": "232млн",
      "badge": "Друид",
      "badgeColor": Colors.purple
    },
    {
      "rank": 2,
      "name": "Machinegunkelly69",
      "score": "232млн",
      "badge": "Друид",
      "badgeColor": Colors.purple
    },
    {
      "rank": 3,
      "name": "Machinegunkelly69",
      "score": "232млн",
      "badge": "Друид",
      "badgeColor": Colors.purple
    },
    {
      "rank": 4,
      "name": "Machinegunkelly69",
      "score": "232млн",
      "badge": "Друид",
      "badgeColor": Colors.purple
    },
    {
      "rank": 5,
      "name": "chico lachowski",
      "score": "167млн",
      "badge": "Новичок",
      "badgeColor": Colors.grey
    },
    {
      "rank": 6,
      "name": "chico lachowski",
      "score": "167млн",
      "badge": "Новичок",
      "badgeColor": Colors.grey
    },
    {"rank": 7, "name": "Ya dobriy", "score": "56млн"},
    {"rank": 8, "name": "Bezymnxa4", "score": "45млн"},
    {"rank": 9, "name": "Rayoshe", "score": "33млн"},
    {"rank": 10, "name": "Kentaro Miura", "score": "32млн"},
    {"rank": 11, "name": "Justin bieber <3", "score": "30млн"},
    {"rank": 12, "name": "Mishura526", "score": "27млн"},
    {"rank": 13, "name": "bopeshka", "score": "26млн"},
    {"rank": 14, "name": "Бу! Испугался? Не боись", "score": "19млн"},
    {"rank": 15, "name": "MBAPPE", "score": "14млн"},
    {"rank": 16, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
    {"rank": 17, "name": "MBAPPE", "score": "14млн"},
  ];

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          SingleChildScrollView(
            child:
                // Фон на всю ширину и высоту экрана
                Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/top_background.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              child:

                  // Прокручиваемый контент
                  Column(
                children: [
                  SizedBox(
                    height: AppSizes.height * 0.2,
                  ),
                  SizedBox(
                    height: AppSizes.height * 0.37, // Фиксируем высоту
                    child: Stack(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: AppSizes.height * 0.15,
                                child: Container(
                                  width: AppSizes.width * 0.4,
                                  height: AppSizes.height * 0.23,
                                  color: Color(0xFF090909),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(AppSizes.width * 0.02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'data',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.06),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: AppSizes.width * 0.05,
                                              height: AppSizes.width * 0.06,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/union_grey.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppSizes.width * 0.01,
                                            ),
                                            Text(
                                              '500млн',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      AppSizes.width * 0.055),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: AppSizes.height * 0.001,
                                        ),
                                        Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.08,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 2,
                                              color: Color(0xFF666666),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: AppSizes.width * 0.1,
                                top: AppSizes.height * 0.3,
                                child: Container(
                                  width: AppSizes.width * 0.4,
                                  height: AppSizes.height * 0.08,
                                  color: Color(0xFF131010),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(AppSizes.width * 0.02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'data',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.05),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: AppSizes.width * 0.04,
                                                  height: AppSizes.width * 0.05,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/union_grey.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: AppSizes.width * 0.01,
                                                ),
                                                Text(
                                                  '500млн',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: AppSizes.width *
                                                          0.04),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: AppSizes.width * 0.15,
                                              height: AppSizes.width * 0.06,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Color(0xFF666666),
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
                              Positioned(
                                right: AppSizes.width * 0.1,
                                top: AppSizes.height * 0.26,
                                child: Container(
                                  width: AppSizes.width * 0.36,
                                  height: AppSizes.height * 0.12,
                                  color: Color(0xFF131010),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(AppSizes.width * 0.02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'data',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.05),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: AppSizes.width * 0.05,
                                              height: AppSizes.width * 0.06,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/union_grey.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppSizes.width * 0.01,
                                            ),
                                            Text(
                                              '500млн',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      AppSizes.width * 0.05),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.08,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 2,
                                              color: Color(0xFF666666),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: AppSizes.width * 0.12,
                                top: AppSizes.height * 0.15,
                                child: CircleAvatar(
                                  radius: AppSizes.width * 0.13,
                                  backgroundColor: Colors.grey,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              Positioned(
                                left: AppSizes.width * 0.12,
                                top: AppSizes.height * 0.19,
                                child: CircleAvatar(
                                  radius: AppSizes.width * 0.13,
                                  backgroundColor: Colors.grey,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              Positioned(
                                top: AppSizes.height * 0.000001,
                                child: CircleAvatar(
                                  radius: AppSizes.width * 0.17,
                                  backgroundColor: Colors.grey,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              Positioned(
                                top: AppSizes.height * 0.23,
                                right: AppSizes.width * 0.1,
                                child: Container(
                                  width: AppSizes.width * 0.12,
                                  height: AppSizes.width * 0.15,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/number_two.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: AppSizes.height * 0.08,
                                right: AppSizes.width * 0.32,
                                child: Container(
                                  width: AppSizes.width * 0.14,
                                  height: AppSizes.width * 0.18,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/number_one.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: AppSizes.height * 0.25,
                                left: AppSizes.width * 0.28,
                                child: Container(
                                  width: AppSizes.width * 0.12,
                                  height: AppSizes.width * 0.15,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/number_three.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: AppSizes.height * 0.01,
                        left: AppSizes.width * 0.05,
                        right: AppSizes.width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFF131010)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: showAll ? users.length : defaultVisibleUsers,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: AppSizes.width * 0.02),
                            child: Row(
                              children: [
                                // Ранг
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    user["rank"].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),

                                // Аватар (заглушка)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[800],
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),

                                SizedBox(width: 10),

                                // Имя и очки
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user["name"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        user["score"],
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                // Бейдж
                                if (user.containsKey("badge"))
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: user["badgeColor"],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      user["badge"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),

                                // Пустая рамка справа
                                if (!user.containsKey("badge"))
                                  Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (users.length > defaultVisibleUsers && !showAll)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width * 0.05),
                      child: Container(
                        width: AppSizes.width,
                        decoration: BoxDecoration(
                          color: Color(0xFF131010),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          // Размещаем кнопку справа
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showAll = true;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: AppSizes.width * 0.02, bottom: AppSizes.height * 0.02),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  // Цвет фона кнопки
                                  borderRadius: BorderRadius.circular(8),
                                  // Закругленные углы
                                  border:
                                      Border.all(color: Colors.grey), // Граница
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.expand_more,
                                        color: Colors.white),
                                    // Иконка стрелки
                                    SizedBox(width: 5),
                                    Text(
                                      "15",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                title: Text(
                  'Таблица лидеров',
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
                    Route route =
                        MaterialPageRoute(builder: (context) => BalancePage());
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
