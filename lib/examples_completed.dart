import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamplesCompletedPage extends StatefulWidget {
  final Function(int) togglePage;

  ExamplesCompletedPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _ExamplesCompletedPageState();
  }
}

class _ExamplesCompletedPageState extends State<ExamplesCompletedPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> examples = [];
  bool isLoading = true;

  Future<void> loadPosts() async {
    List<Map<String, dynamic>> fetchExamples =
        await _databaseService.fetchUserTasksAndDetails();
    if (mounted) {
      setState(() {
        examples = fetchExamples;
        print(examples);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
          child: SizedBox(
            height: AppSizes.height * 0.7, // ограничение по высоте
            child: ListView.builder(
                itemCount: examples.length,
                itemBuilder: (context, index) {
                  final example = examples[index];
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: AppSizes.width * 0.9,
                            height: AppSizes.width * 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.width * 0.03,
                                vertical: AppSizes.height * 0.01),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background_container_completed_examples.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Positioned(
                            top: AppSizes.height * 0.005,
                            left: AppSizes.width * 0.03,
                            right: AppSizes.width * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${example['status'] == 'true' ? 'Выполнено' : example['status'] == 'false' ? 'Не выполнено...' : 'На проверке...'}',
                                      style: TextStyle(
                                        color: example['status'] == 'true'
                                            ? Color(0xFF68E30B)
                                            : example['status'] == 'false'
                                                ? Color(0xFFC22323)
                                                : Color(0xFFFDC421),
                                        fontSize: AppSizes.width * 0.055,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    example['status'] == 'true'
                                        ? Row(
                                            children: [
                                              SizedBox(width: AppSizes.width * 0.01,),
                                              Container(
                                                width: AppSizes.width * 0.06,
                                                height: AppSizes.width * 0.06,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/icons/sponsor_check_examples.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${example['status'] == 'true' ? '100%' : example['status'] == 'false' ? '0%' : '100%'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.045,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      width: AppSizes.width * 0.4,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: LinearProgressIndicator(
                                          value: example['status'] == 'true'
                                              ? 1.0
                                              : example['status'] == 'false'
                                                  ? 0.0
                                                  : 1.0,
                                          minHeight: 16,
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            example['status'] == 'true'
                                                ? Color(0xFF68E30B)
                                                : example['status'] == 'false'
                                                    ? Color(0xFFC22323)
                                                    : Color(0xFFFDC421),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: AppSizes.height * 0.105,
                            left: AppSizes.width * 0.03,
                            right: AppSizes.width * 0.02,
                            child: Text(
                              '${example['title']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.width * 0.055,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Positioned(
                            top: AppSizes.height * 0.13,
                            left: AppSizes.width * 0.03,
                            right: AppSizes.width * 0.02,
                            child: Text(
                              '${example['description']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.width * 0.045,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSizes.height * 0.03,
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
