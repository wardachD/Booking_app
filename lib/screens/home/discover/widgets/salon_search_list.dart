import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/salon_avatar_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SalonSearchList extends StatefulWidget {
  final Stream<List<SalonModel>> salonsSearchFuture;
  final bool isDistanceNeeded;
  final bool sortByDistance;

  const SalonSearchList({
    Key? key,
    required this.salonsSearchFuture,
    required this.isDistanceNeeded,
    required this.sortByDistance,
  }) : super(key: key);

  @override
  State<SalonSearchList> createState() => _SalonSearchListState();
}

class _SalonSearchListState extends State<SalonSearchList> {
  ScrollController _scrollViewController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _showAppbar = true;
  bool _isOnTop = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          Provider.of<AnimatedTopBarProvider>(context, listen: false)
              .updateField(false);
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown && _scrollViewController.position.pixels < 70) {
          isScrollingDown = false;
          _showAppbar = true;
          Provider.of<AnimatedTopBarProvider>(context, listen: false)
              .updateField(true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SalonModel>>(
        stream: widget.salonsSearchFuture,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var salons = snapshot.data;
            // if (salons!.isEmpty) {

            //   return Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Image.asset('assets/images/znajdz_to.png',
            //             width: MediaQuery.sizeOf(context).width * 0.9),
            //         const SizedBox(height: 60),
            //       ],
            //     ),
            //   );
            // }
            if (widget.sortByDistance) {
              salons!.sort(
                  (a, b) => a.distanceFromQuery.compareTo(b.distanceFromQuery));
            } else {
              salons!.sort((a, b) => b.review.compareTo(a.review));
            }

            return AnimatedSwitcher(
              reverseDuration: Duration(milliseconds: 500),
              duration: Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve:
                  Curves.easeInOut, // Set the duration for the switch animation
              child: salons.isNotEmpty
                  ? ListView.builder(
                      cacheExtent: (MediaQuery.of(context).size.height * 0.4) *
                          salons.length,
                      physics: BouncingScrollPhysics(),
                      key:
                          UniqueKey(), // Set a unique key to trigger the animation
                      controller: _scrollViewController,
                      itemCount: salons.length,
                      itemBuilder: (context, index) {
                        var salon = salons[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to SalonDetailsScreen when a salon is tapped
                            Get.to(() => SalonDetailsScreen(salonModel: salon));
                          },
                          child: SalonAvatar(salon: salon),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/znajdz_to.png',
                              width: MediaQuery.sizeOf(context).width * 0.9),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
            );
          }
        });
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Proszę czekać...'),
          ],
        ),
      ),
    );
  }
}
