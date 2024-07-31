import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../login/login_cubit/login_cubit.dart';
import '../login/login_cubit/login_states.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatelessWidget {
  final boardController = PageController();
  final List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/onboard_1.jpg',
        title: 'Shop All Products',
        body: 'You Can Find Many Products You Search For'),
    BoardingModel(
        image: 'assets/images/onboard_2.jpg',
        title: 'Low Coast ',
        body: 'We Have Much Offers For you And Fair Price'),
    BoardingModel(
        image: 'assets/images/onboard_3.jpg',
        title: 'Easy To Use',
        body: 'Very Useful And Easy'),
  ];

  OnBoardingScreen({super.key});

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, LoginStates state) {},
      builder: (BuildContext context, LoginStates state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: defaultColor,
              actions: [
                TextButton(
                    onPressed: () {
                     onBoardingPass(context);
                    },
                    child: const Text('skip')),
                IconButton(
                    onPressed: () {
                      cubit.changeAppMode();
                      // print('isDark in onBoarding = ${(cubit.isDark)}');
                    },
                    icon: const Icon(Icons.brightness_medium_rounded))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (int index) {
                        if (index == boarding.length - 1) {
                          isLast = true;
                        } else {
                          isLast = false;
                        }
                      },
                      controller: boardController,
                      itemBuilder: (context, index) => buildBoardingItem(
                        boarding[index],
                      ),
                      itemCount: boarding.length,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SmoothPageIndicator(
                        controller: boardController,
                        count: boarding.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 12,
                          dotWidth: 20,
                          //activeDotColor: defaultColor
                        ),
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          if (isLast) {
                            onBoardingPass(context);
                          } else {
                            boardController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.bounceInOut);
                          }
                        },
                        backgroundColor: defaultColor,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            model.body,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      );
}
