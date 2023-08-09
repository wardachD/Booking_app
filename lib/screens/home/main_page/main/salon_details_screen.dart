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
    with SingleTickerProviderStateMixin {
  final SalonModel salonModel;
  double _imageHeight = 0.0;
  double _initialSwipeOffset = 0.0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageHeight = MediaQuery.of(context).size.width * 0.65;
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
          _imageHeight = MediaQuery.of(context).size.width * 0.65;
        } else {
          _imageHeight = 0.0;
        }
      });
    }
  }

  double imageOpacity() {
    return (_imageHeight / (MediaQuery.of(context).size.width * 0.63))
        .clamp(0.0, 1.0);
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
                          _initialSwipeOffset = details.localPosition.dy;
                        }
                        ..onUpdate = (DragUpdateDetails details) {
                          setState(() {
                            double currentOffset = details.localPosition.dy;
                            if (_tabController!.index < 1) {
                              _imageHeight = max(
                                  0,
                                  _imageHeight -
                                      _initialSwipeOffset +
                                      currentOffset);
                              _initialSwipeOffset = currentOffset;
                            } else {
                              _imageHeight = 0;
                            }
                          });
                        }
                        ..onEnd = (DragEndDetails details) {};
                    },
                  )
                },
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: salonDetailsTitle,
                      ),
                      const SizedBox(height: 10),
                      Opacity(
                        opacity: imageOpacity(),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width,
                            maxHeight: MediaQuery.sizeOf(context).width * 0.65,
                          ),
                          height: _imageHeight,
                          width: MediaQuery.sizeOf(context).width,
                          child:
                              CachedNetworkImage(imageUrl: salonModel.avatar),
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(text: "services"),
                          Tab(text: "reviews"),
                          Tab(text: "portfolio"),
                          Tab(text: "details"),
                        ],
                      ),
                      const SizedBox(height: 5),
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
            style: GoogleFonts.playfairDisplay(
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
