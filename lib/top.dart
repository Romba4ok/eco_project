import 'package:Eco/appSizes.dart';
import 'package:Eco/balance.dart';
import 'package:Eco/supabase_config.dart';
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
  bool showAll = false;
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  int startIndex = 3; // Начинаем с 3-го элемента
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    loadLeaderboard(); // Загружаем данные
  }

  void loadLeaderboard() async {
    List<Map<String, dynamic>> leaderboard =
        await databaseService.fetchLeaderboard();
    setState(() {
      users = leaderboard;
      isLoading = false; // Данные загружены
    });
  }

  String formatScore(int? score) {
    if (score == null) return "0";

    if (score >= 1000000000) {
      return _removeTrailingZero(score / 1000000000) + "Млрд";
    } else if (score >= 1000000) {
      return _removeTrailingZero(score / 1000000) + "млн";
    } else if (score >= 1000) {
      return _removeTrailingZero(score / 1000) + "К";
    } else {
      return score.toString();
    }
  }

// Убираем лишние нули (например, "1.0К" → "1К")
  String _removeTrailingZero(double value) {
    return value.toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: isLoading
          ? Container(
              width: AppSizes.width,
              height: AppSizes.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app/loadPage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: AppSizes.width * 0.4,
                  height: AppSizes.height * 0.35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/app/loadLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child:

                      Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/top_background.png'),
                        fit: users.length > 15 ? BoxFit.contain : BoxFit.fill, // Условие
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
                                          padding: EdgeInsets.all(
                                              AppSizes.width * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                users[0]["name"].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.06),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        AppSizes.width * 0.05,
                                                    height:
                                                        AppSizes.width * 0.06,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/icons/union_grey.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        AppSizes.width * 0.01,
                                                  ),
                                                  Text(
                                                    formatScore(
                                                        users[0]['balance']),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            AppSizes.width *
                                                                0.055),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: AppSizes.height * 0.001,
                                              ),
                                        users[0]["badge"] != null
                                            ? Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.1,
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            gradient: users[0]["badgeGradient"] ??
                                                LinearGradient(
                                                  colors: [Colors.grey, Colors.grey[300]!],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: ShaderMask(
                                              shaderCallback: (bounds) {
                                                return (users[0]["badgeTextGradient"] as LinearGradient?)?.createShader(bounds) ??
                                                    LinearGradient(
                                                      colors: [Colors.white, Colors.grey[300]!],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ).createShader(bounds);
                                              },
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                users[0]["badge"] ?? "Без титула", // Если ранга нет, пишем "Без титула"
                                                style: TextStyle(
                                                  fontSize: AppSizes.width * 0.03,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white, // Цвет обязательно нужен для ShaderMask
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.08,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey), // 🔹 Граница, если ранга нет
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "Без титула",
                                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                                          padding: EdgeInsets.all(
                                              AppSizes.width * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                users[2]["name"].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.05),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: AppSizes.width *
                                                            0.04,
                                                        height: AppSizes.width *
                                                            0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/icons/union_grey.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: AppSizes.width *
                                                            0.01,
                                                      ),
                                                      Text(
                                                        formatScore(users[2]
                                                            ['balance']),
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                AppSizes.width *
                                                                    0.04),
                                                      ),
                                                    ],
                                                  ),
                                          users[2]["badge"] != null
                                              ? Container(
                                            width: AppSizes.width * 0.25,
                                            height: AppSizes.width * 0.07,
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              gradient: users[2]["badgeGradient"] ??
                                                  LinearGradient(
                                                    colors: [Colors.grey, Colors.grey[300]!],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return (users[2]["badgeTextGradient"] as LinearGradient?)?.createShader(bounds) ??
                                                      LinearGradient(
                                                        colors: [Colors.white, Colors.grey[300]!],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ).createShader(bounds);
                                                },
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  users[2]["badge"] ?? "Без титула", // Если ранга нет, пишем "Без титула"
                                                  style: TextStyle(
                                                    fontSize: AppSizes.width * 0.02,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white, // Цвет обязательно нужен для ShaderMask
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                              : Container(
                                            width: AppSizes.width * 0.25,
                                            height: AppSizes.width * 0.07,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.grey), // 🔹 Граница, если ранга нет
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "Без титула",
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
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
                                          padding: EdgeInsets.all(
                                              AppSizes.width * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                users[1]["name"].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.05),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        AppSizes.width * 0.05,
                                                    height:
                                                        AppSizes.width * 0.06,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/icons/union_grey.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        AppSizes.width * 0.01,
                                                  ),
                                                  Text(
                                                    formatScore(
                                                        users[1]['balance']),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            AppSizes.width *
                                                                0.05),
                                                  ),
                                                ],
                                              ),
                                        users[1]["badge"] != null
                                            ? Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.08,
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            gradient: users[1]["badgeGradient"] ??
                                                LinearGradient(
                                                  colors: [Colors.grey, Colors.grey[300]!],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: ShaderMask(
                                              shaderCallback: (bounds) {
                                                return (users[1]["badgeTextGradient"] as LinearGradient?)?.createShader(bounds) ??
                                                    LinearGradient(
                                                      colors: [Colors.white, Colors.grey[300]!],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ).createShader(bounds);
                                              },
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                users[1]["badge"] ?? "Без титула", // Если ранга нет, пишем "Без титула"
                                                style: TextStyle(
                                                  fontSize: AppSizes.width * 0.025,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white, // Цвет обязательно нужен для ShaderMask
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(
                                          width: AppSizes.width * 0.25,
                                          height: AppSizes.width * 0.08,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey), // 🔹 Граница, если ранга нет
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "Без титула",
                                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                                        backgroundImage: (users[1]["avatar"] !=
                                                    null &&
                                                users[1]["avatar"].isNotEmpty)
                                            ? NetworkImage(users[1]["avatar"])
                                            : null,
                                        // Загружаем изображение, если есть

                                        backgroundColor:
                                            (users[2]["avatar"] == null ||
                                                    users[1]["avatar"].isEmpty)
                                                ? Colors.white
                                                : Colors.transparent,
                                        // Фон, если аватар отсутствует

                                        child: (users[1]["avatar"] == null ||
                                                users[1]["avatar"].isEmpty)
                                            ? Text(
                                                users[1]["name"] != null &&
                                                        users[0]["name"]
                                                            .isNotEmpty
                                                    ? users[1]["name"][0]
                                                        .toUpperCase() // Берем первую букву имени, если оно есть
                                                    : "?",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      AppSizes.width * 0.05,
                                                ),
                                              )
                                            : null, // Показываем букву, если нет аватара
                                      ),
                                    ),
                                    Positioned(
                                      left: AppSizes.width * 0.12,
                                      top: AppSizes.height * 0.19,
                                      child: CircleAvatar(
                                        radius: AppSizes.width * 0.13,
                                        backgroundImage: (users[2]["avatar"] !=
                                                    null &&
                                                users[2]["avatar"].isNotEmpty)
                                            ? NetworkImage(users[2]["avatar"])
                                            : null,
                                        // Загружаем изображение, если есть

                                        backgroundColor:
                                            (users[2]["avatar"] == null ||
                                                    users[2]["avatar"].isEmpty)
                                                ? Colors.white
                                                : Colors.transparent,
                                        // Фон, если аватар отсутствует

                                        child: (users[2]["avatar"] == null ||
                                                users[2]["avatar"].isEmpty)
                                            ? Text(
                                                users[2]["name"] != null &&
                                                        users[0]["name"]
                                                            .isNotEmpty
                                                    ? users[2]["name"][0]
                                                        .toUpperCase() // Берем первую букву имени, если оно есть
                                                    : "?",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      AppSizes.width * 0.05,
                                                ),
                                              )
                                            : null, // Показываем букву, если нет аватара
                                      ),
                                    ),
                                    Positioned(
                                      top: AppSizes.height * 0.000001,
                                      child: CircleAvatar(
                                        radius: AppSizes.width * 0.17,
                                        backgroundImage: (users[0]["avatar"] !=
                                                    null &&
                                                users[0]["avatar"].isNotEmpty)
                                            ? NetworkImage(users[0]["avatar"])
                                            : null,
                                        // Загружаем изображение, если есть

                                        backgroundColor:
                                            (users[0]["avatar"] == null ||
                                                    users[0]["avatar"].isEmpty)
                                                ? Colors.white
                                                : Colors.transparent,
                                        // Фон, если аватар отсутствует

                                        child: (users[0]["avatar"] == null ||
                                                users[0]["avatar"].isEmpty)
                                            ? Text(
                                                users[0]["name"] != null &&
                                                        users[0]["name"]
                                                            .isNotEmpty
                                                    ? users[0]["name"][0]
                                                        .toUpperCase() // Берем первую букву имени, если оно есть
                                                    : "?",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      AppSizes.width * 0.05,
                                                ),
                                              )
                                            : null, // Показываем букву, если нет аватара
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
                                                'assets/icons/number_two.png'),
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
                                                'assets/icons/number_one.png'),
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
                                                'assets/icons/number_three.png'),
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
                              itemCount: showAll
                                  ? (users.length - startIndex)
                                      .clamp(0, users.length)
                                  : (users.length - startIndex)
                                      .clamp(0, defaultVisibleUsers),
                              itemBuilder: (context, index) {
                                int adjustedIndex =
                                    index + startIndex; // Смещаем индекс

                                if (adjustedIndex >= users.length)
                                  return SizedBox(); // Проверка выхода за границы списка

                                final user = users[adjustedIndex];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: AppSizes.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Левая часть: Ранг + Аватар + Имя
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: AppSizes.width * 0.08,
                                            child: Text(
                                              user["rank"].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              textAlign: TextAlign
                                                  .center, // Центрируем текст по горизонтали
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          // Чтобы не было прилипаний
                                          CircleAvatar(
                                            radius: AppSizes.width * 0.05,
                                            // Размер аватара
                                            backgroundImage: (user["avatar"] !=
                                                        null &&
                                                    user["avatar"].isNotEmpty)
                                                ? NetworkImage(user["avatar"])
                                                : null,
                                            // Загружаем изображение, если есть

                                            backgroundColor:
                                                (user["avatar"] == null ||
                                                        user["avatar"].isEmpty)
                                                    ? Colors.white
                                                    : Colors.transparent,
                                            // Фон, если аватар отсутствует

                                            child: (user["avatar"] == null ||
                                                    user["avatar"].isEmpty)
                                                ? Text(
                                                    user["name"] != null &&
                                                            user["name"]
                                                                .isNotEmpty
                                                        ? user["name"][0]
                                                            .toUpperCase() // Берем первую букву имени, если оно есть
                                                        : "?",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          AppSizes.width * 0.05,
                                                    ),
                                                  )
                                                : null, // Показываем букву, если нет аватара
                                          ),
                                          SizedBox(
                                              width: AppSizes.width * 0.02),
                                          SizedBox(
                                            width: 100,
                                            // Фиксируем ширину имени, чтобы все колонки были ровными
                                            child: Text(
                                              user["name"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              overflow: TextOverflow
                                                  .ellipsis, // Обрезка длинных имен
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Центральная часть: Иконка + Очки
                                      Row(
                                        children: [
                                          Container(
                                            width: AppSizes.width * 0.04,
                                            height: AppSizes.width * 0.05,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/icons/union_grey.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: AppSizes.width * 0.005),
                                          Text(
                                            formatScore(
                                                user['balance']),
                                            // ПРАВИЛЬНО
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),

                                      // Правая часть: Бейдж (если есть) или пустой контейнер-заглушка
                                      user["badge"] != null
                                          ? Container(
                                        width: AppSizes.width * 0.19,
                                        height: AppSizes.height * 0.04,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: user["badgeGradient"] ??
                                              LinearGradient(
                                                colors: [Colors.grey, Colors.grey[300]!],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: ShaderMask(
                                            shaderCallback: (bounds) {
                                              return (user["badgeTextGradient"] as LinearGradient?)?.createShader(bounds) ??
                                                  LinearGradient(
                                                    colors: [Colors.white, Colors.grey[300]!],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ).createShader(bounds);
                                            },
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              user["badge"] ?? "Без титула", // Если ранга нет, пишем "Без титула"
                                              style: TextStyle(
                                                fontSize: AppSizes.width * 0.03,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white, // Цвет обязательно нужен для ShaderMask
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                          : Container(
                                        width: AppSizes.width * 0.19,
                                        height: AppSizes.height * 0.04,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey), // 🔹 Граница, если ранга нет
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "Без титула",
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
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
                                    padding: EdgeInsets.only(
                                        right: AppSizes.width * 0.02,
                                        bottom: AppSizes.height * 0.02),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        // Цвет фона кнопки
                                        borderRadius: BorderRadius.circular(8),
                                        // Закругленные углы
                                        border: Border.all(
                                            color: Colors.grey), // Граница
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
                                                color: Colors.white,
                                                fontSize: 16),
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
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.07),
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: AppSizes.width * 0.08,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
