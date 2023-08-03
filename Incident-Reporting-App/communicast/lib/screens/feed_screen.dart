import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/screens/search_profile_screen.dart';
import 'package:communicast/screens/search_screen.dart';
import 'package:communicast/utils/global_variable.dart';
import 'package:communicast/widgets/post_card.dart';
import 'package:communicast/providers/notifications.dart';
import 'package:latlong2/latlong.dart';

import '../models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isShowUsers = false;
  bool isTapped = false;
  bool isNearby = false;
  List following = [];
  String? locationAddress;
  double lat = 0;
  double long = 0;
  double latitude = 0;
  double longitude = 0;
  late LatLng currentCenter = LatLng(lat, long);
  int count = 0;
  bool noNearby = true;
  int nearbyPostCounter = 0;
  //list counter
  List<int> listCounter = [];

  final user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream = FirebaseFirestore
      .instance
      .collection("posts")
      .orderBy("datePublished", descending: true)
      .snapshots();

  notifChecker() async {
    postsStream.listen(
      (event) async {
        var postUid = event.docs.first.get('uid');
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        lat = position.latitude;
        long = position.longitude;
        latitude = event.docs.first.get('latitude');
        longitude = event.docs.first.get('longitude');
        late var distanceNotif = Geolocator.distanceBetween(
          lat,
          long,
          latitude,
          longitude,
        );
        print('==========================================');
        print('NOTIF CHECKER');
        print('distanceNotif : $distanceNotif');
        print('lat: $lat');
        print('long: $long');
        print('latitude: $latitude');
        print('longitude: $longitude');
        print('==========================================\n\n');
        if (event.docs.isEmpty ||
            postUid == user!.uid ||
            distanceNotif > 10000) {
          return;
        } else {
          if (event.docs.first.get('notificationSent') == true) {
            return;
          } else {
            Notifications.showNotifications(event.docs.first);
            FirebaseFirestore.instance
                .collection('posts')
                .doc(event.docs.first.id)
                .update({
              'notificationSent': true,
            });
          }
        }
      },
    );
  }

  Future<int> isPostNearby(double postLat, double postLon) async {
    setState(() {
      isLoading = true;
    });
    int isNB = 0;
    print("\n==============\n");
    print("This is isPOstNearby Function!!!!!");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double curLat = position.latitude;
    double curLon = position.longitude;
    var distance = Geolocator.distanceBetween(
      curLat,
      curLon,
      postLat,
      postLon,
    );

    print('===============================');
    print('curLat : ${curLat.toString()}');
    print('curLon : ${curLon.toString()}');
    print('postLat : ${postLat.toString()}');
    print('postLon : ${postLon.toString()}');
    print('distance : ${distance.toString()}');
    print('===============================');
    if (distance > 10000) {
      print("Nearby = False");
      print("\n==============\n");
      setState(() {
        isLoading = false;
      });
    } else {
      print("Nearby = True");
      setState(() {
        nearbyPostCounter = (nearbyPostCounter + 1);
        isNB = 1;
        listCounter.add(nearbyPostCounter);
        isLoading = false;
      });
      print("nearbyPostCounter: $nearbyPostCounter");

      print("\n==============\n");
    }
    return isNB;
  }

  iterateDocuments() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map data = (result.data() as Map);
        //print("\n\n==============\n");
        var docLat = data['latitude'];
        var docLon = data['longitude'];
        print("\n========================================================\n");
        print("ITERATE DOCUMENTS");
        print("\n==============\n");
        print("Fetched Data: ");
        print('docLat: $docLat');
        print('docLon: $docLon');
        print("\n==============\n");
        Future<int> nearby = isPostNearby(docLat, docLon);
        print("nearby: $nearby");
        print(
            "\n========================================================\n\n\n");
      });
    });
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.country}'; //, ${placemark.postalCode}';
    print('==========================================');
    print('GET CURRENT LOCATION');
    print('LATITUDE: ${position.latitude}, LONGITUDE: ${position.longitude}');
    print('completeAddress: $completeAddress');
    setState(() {
      locationAddress = completeAddress;
      lat = position.latitude;
      long = position.longitude;
      currentCenter = LatLng(lat, long);
      print('LOCATIONADDRESS: $locationAddress || LAT: $lat || LONG: $long');
      print('==========================================\n\n');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Notifications.init();
    _getCurrentLocation();
    iterateDocuments();
    print("\n========================================================\n");
    print("Total nearby posts: $nearbyPostCounter");
    print("\n========================================================\n");
    notifChecker();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print('LIST COUNTER: ${listCounter.length}');
    int nearbyPosts = listCounter.length;

    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image(
                        image: AssetImage('assets/images/CommuniCast.png'),
                        height: 20),
                    SizedBox(width: 5),
                    Text(
                      'CommuniCast',
                      style: AppTextStyles.title1.copyWith(
                        color: AppColors.blueAccent,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                              child: const SearchScreen(),
                            ),
                          );
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isNearby = false;
                      });
                    },
                    child: Text(
                      'All',
                      style: AppTextStyles.body2.copyWith(
                        color: isNearby ? AppColors.grey : AppColors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isNearby = true;

                        //function
                      });
                    },
                    child: Text(
                      'Nearby',
                      style: AppTextStyles.body2.copyWith(
                        color: isNearby ? AppColors.blueAccent : AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: postsStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              //if snapshot data is empty
              //no posts in general
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'No posts yet.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                );
              } else {
                if (!isNearby) {
                  noNearby = false;
                  //All posts
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        itemCount: isNearby
                            ? nearbyPostCounter
                            : snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize ? width * 0.3 : 0,
                            vertical: width > webScreenSize ? 15 : 0,
                          ),
                          child: PostCard(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  if (nearbyPosts != 0) {
                    if (noNearby == false) {
                      return isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                latitude = snap['latitude'];
                                longitude = snap['longitude'];
                                var distanceInMeters =
                                    Geolocator.distanceBetween(
                                  lat,
                                  long,
                                  latitude,
                                  longitude,
                                );
                                if (distanceInMeters <= 10000) {
                                  print("NEARBY");
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: width > webScreenSize
                                          ? width * 0.3
                                          : 0,
                                      vertical: width > webScreenSize ? 15 : 0,
                                    ),
                                    child: PostCard(
                                      snap: snap.data(),
                                    ),
                                  );
                                } else if (distanceInMeters > 10000) {
                                  print("NOT NEARBY");
                                  return Container();
                                } else {
                                  noNearby = true;
                                  return Container();
                                }
                              });
                    } else {
                      return isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'No nearby posts.',
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                            );
                    }
                  } else {
                    return isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'No nearby posts.',
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                          );
                  }
                }
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
