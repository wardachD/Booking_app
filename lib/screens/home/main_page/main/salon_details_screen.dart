import 'dart:math';
import 'package:buttons_tabbar2/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/salon_details.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/salon_reviews.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/widgets/salon_details_widgets/salon_portfolio_details.dart';
import 'screens/widgets/salon_details_widgets/salon_services_details.dart';

class SalonDetailsScreen extends StatefulWidget {
  final SalonModel salonModel;

  const SalonDetailsScreen({Key? key, required this.salonModel})
      : super(key: key);

  @override
  _SalonDetailsScreenState createState() =>
      _SalonDetailsScreenState(salonModel);
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen>
    with TickerProviderStateMixin {
  final SalonModel salonModel;
  double _imageHeight = 300;
  double _initialSwipeOffset = 0.0;
  TabController? _tabController;
  double _deltaOffset = 0.0;
  double _currentOffset = 0.0;
  late double currentOffset;
  late double deltaOffset;
  late AnimationController _animationControllerFromMax;
  late AnimationController _animationControllerFromMin;
  late Animation<double> _heightAnimationFromMax;
  late Animation<double> _heightAnimationFromMin;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    _animationControllerFromMin = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 300), // Czas trwania animacji (500 milisekund)
    );
    _animationControllerFromMax = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 300), // Czas trwania animacji (500 milisekund)
    );
    _heightAnimationFromMin = Tween<double>(
      begin: 0.0, // Początkowa wysokość
      end: 400.0, // Końcowa wysokość
    ).animate(_animationControllerFromMax)
      ..addListener(() {
        setState(() {
          _imageHeight = _heightAnimationFromMin.value;
        });
      });
    _heightAnimationFromMax = Tween<double>(
      begin: 400.0, // Początkowa wysokość
      end: 0.0, // Końcowa wysokość
    ).animate(_animationControllerFromMin)
      ..addListener(() {
        setState(() {
          _imageHeight = _heightAnimationFromMax.value;
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageHeight = MediaQuery.sizeOf(context).width;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _animationControllerFromMax.dispose();
    _animationControllerFromMin.dispose();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (_tabController!.index > 0) {
        _tabController!.animateTo(_tabController!.index - 1);
      }
    } else {
      if (_tabController!.index < 3) {
        _tabController!.animateTo(_tabController!.index + 1);
      }
    }
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        if (_tabController!.index == 0) {
          if (_imageHeight != 300) {
            increaseImageHeightWithAnimation();
          }
        } else {
          if (_imageHeight != 0) {
            decreaseImageHeightWithAnimation();
          }
        }
      });
    }
  }

  void decreaseImageHeightWithAnimation() {
    _animationControllerFromMin.forward(from: 0.0);
  }

  void increaseImageHeightWithAnimation() {
    _animationControllerFromMax.forward(from: 0.0);
  }

  _SalonDetailsScreenState(this.salonModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
          child: Stack(
            children: [
              RawGestureDetector(
                gestures: {
                  AllowMultipleGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          AllowMultipleGestureRecognizer>(
                    () => AllowMultipleGestureRecognizer(),
                    (AllowMultipleGestureRecognizer instance) {
                      instance
                        ..onStart = (DragStartDetails details) {
                          // muszę rozpocząć nagrywanie skrolla
                          _initialSwipeOffset = details.localPosition.dy;
                        }
                        ..onUpdate = (DragUpdateDetails details) {
                          currentOffset = details.localPosition.dy;
                          deltaOffset = currentOffset - _initialSwipeOffset;
                          setState(() {
                            if (_tabController!.index == 0) {
                              if (deltaOffset > 50) {
                                if (_imageHeight != 300) {
                                  increaseImageHeightWithAnimation();
                                }
                              }
                              if (deltaOffset < -50) {
                                if (_imageHeight != 0) {
                                  decreaseImageHeightWithAnimation();
                                }
                              }
                            }
                          });
                        }
                        ..onEnd = (DragEndDetails details) {
                          // Handle the end of the swipe if needed
                        };
                    },
                  )
                },
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            children: salonDetailsTitle,
                          ),
                          const SizedBox(height: 10),
                          Opacity(
                            opacity: 1.0,
                            child: SizedBox(
                              child: CachedNetworkImage(
                                imageUrl: salonModel.avatar,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: _imageHeight / 2.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ButtonsTabBar(
                            controller: _tabController,
                            radius: 16.0,
                            height: 45,
                            backgroundColorGlobal:
                                const Color.fromARGB(255, 231, 230, 230),
                            backgroundColor:
                                const Color.fromARGB(255, 253, 162, 155),
                            unselectedBackgroundColor:
                                const Color.fromARGB(255, 231, 230, 230),
                            unselectedLabelStyle:
                                const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            tabs: const [
                              Tab(text: "services"),
                              Tab(text: "reviews"),
                              Tab(text: "portfolio"),
                              Tab(text: "details"),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) =>
                                  _handleSwipe(details),
                              child: Center(
                                  child: SalonServicesDetails(
                                      salonModel: salonModel)),
                            ),
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) =>
                                  _handleSwipe(details),
                              child: Center(
                                  child: SalonReviews(salonId: salonModel.id)),
                            ),
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) =>
                                  _handleSwipe(details),
                              child: Center(
                                  child: SalonPortfolioDetails(
                                      imageUrl: salonModel.avatar)),
                            ),
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) =>
                                  _handleSwipe(details),
                              child: Center(
                                  child: SalonDetails(salonModel: salonModel)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get salonDetailsTitle {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Get.back();
        },
      ),
      const Spacer(flex: 1),
      Column(
        children: <Widget>[
          Text(
            salonModel.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.anybody(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${salonModel.addressCity} ${salonModel.addressPostalCode}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 66, 66, 66),
            ),
          ),
        ],
      ),
      const Spacer(flex: 2),
    ];
  }
}

class AllowMultipleGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
