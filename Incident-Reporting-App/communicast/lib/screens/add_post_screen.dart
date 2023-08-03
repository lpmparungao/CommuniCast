import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/providers/user_provider.dart';
import 'package:communicast/resources/firestore_methods.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/indicators.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:communicast/models/post.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  bool notificationSent = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _indicatorController = TextEditingController();
  // String? title = 'test title';
  // String? description;
  String? locationAddress;
  //String? indicator = 'CODE BLUE';
  String? _selectedIndicator;
  String countrySet = 'PH';
  late double lat = 0;
  late double long = 0;
  late LatLng currentCenter = LatLng(lat, long);
  MapController mapController = MapController();
  final String apiKey = "nNpeA6MVcnH0q5w6LfXTP2uNR58WIcKI";
  DateTime timestamp = DateTime.now();

  final List<Marker> markers = List.empty(growable: true);
  List<String> _indicators = [
    'CODE RED',
    'CODE AMBER',
    'CODE BLUE',
    'CODE GREEN',
    'CODE BLACK',
  ];

  double currentZoom = 16.0;

  void _zoom() {
    currentZoom = currentZoom + 1.0;
    print('Zoom: $currentZoom');
    mapController.move(currentCenter, currentZoom);
  }

  void _unzoom() {
    currentZoom = currentZoom - 1.0;
    print('Zoom: $currentZoom');
    mapController.move(currentCenter, currentZoom);
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Center(
            child: Text(
              'Report an Incident',
              style: AppTextStyles.title,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo', style: AppTextStyles.body),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery',
                    style: AppTextStyles.body),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text("Cancel",
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    if (_titleController.text == "" ||
        _descriptionController.text == "" ||
        _selectedIndicator == null) {
      showSnackBar(context, "Please fill all the fields");
      isLoading = false;
      return;
    } else {
      // start the loading
      try {
        // upload to storage and db
        String res = await FireStoreMethods().uploadPost(
          _titleController.text,
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          _locationController.text,
          lat,
          long,
          _selectedIndicator!,
          notificationSent,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 200),
                child: const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
              (route) => false);
          showSnackBar(
            context,
            'Posted!',
          );
          clearImage();
          clearText();
        } else {
          showSnackBar(context, res);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void clearText() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedIndicator = null;
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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
    print('LATITUDE: ${position.latitude}, LONGITUDE: ${position.longitude}');
    print('==========================================');
    print('completeAddress: $completeAddress');
    print('==========================================');
    _locationController.text = completeAddress;
    setState(() {
      locationAddress = completeAddress;
      lat = position.latitude;
      long = position.longitude;
      currentCenter = LatLng(lat, long);
      print('LOCATIONADDRESS: $locationAddress || LAT: $lat || LONG: $long');
    });
  }

  SuperTooltip? tooltip;

  getMarkers() async {
    print("\n\n==============\n");
    print("FETCHING DATA!!!!!!!!!!");
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
        var docTitle = data['title'];
        var docIndicator = data['indicator'];
        // print("\n==============\n");
        // print("Fetched Data: ");
        // print(docTitle);
        // print(docIndicator);
        // print(docLat);
        // print(docLon);
        // print("\n==============\n");
        String title = docTitle.toString();
        String indicator = docIndicator.toString();
        var icon = 61242;
        Color color = Colors.white;
        bool dark = false;
        if (indicator == 'CODE RED') {
          icon = 57912;
          color = Colors.red;
        } else if (indicator == 'CODE AMBER') {
          icon = 983712;
          color = Colors.amber;
        } else if (indicator == 'CODE BLUE') {
          icon = 983744;
          color = Colors.blue;
        } else if (indicator == 'CODE GREEN') {
          icon = 983699;
          color = Colors.green;
        } else if (indicator == 'CODE BLACK') {
          icon = 62784;
          color = Colors.black;
          dark = true;
        }
        Future<bool> _willPopCallback() async {
          // If the tooltip is open we don't pop the page on a backbutton press
          // but close the ToolTip
          if (tooltip!.isOpen) {
            tooltip!.close();
            return false;
          }
          return true;
        }

        void onTap() {
          if (tooltip != null && tooltip!.isOpen) {
            tooltip!.close();
            return;
          }

          var renderBox = context.findRenderObject() as RenderBox;
          final overlay =
              Overlay.of(context)!.context.findRenderObject() as RenderBox?;

          var targetGlobalCenter = renderBox.localToGlobal(
              renderBox.size.center(Offset.zero),
              ancestor: overlay);

          // We create the tooltip on the first use
          tooltip = SuperTooltip(
            popupDirection: TooltipDirection.up,
            closeButtonColor: Colors.white,
            closeButtonSize: 15,
            showCloseButton: ShowCloseButton.inside,
            borderWidth: 0,
            backgroundColor: color,
            shadowColor: Colors.transparent,
            borderColor: color,
            arrowLength: 0,
            content: Material(
              child: Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(IconData(icon, fontFamily: 'MaterialIcons'),
                        size: 30.0, color: Colors.white),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$title',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text('Type: $indicator',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          tooltip!.show(context);
        }

        var marker = Marker(
          width: 160.0,
          height: 55.0,
          point: LatLng(docLat, docLon),
          builder: (BuildContext context) => Column(
            children: [
              WillPopScope(
                onWillPop: _willPopCallback,
                child: GestureDetector(
                  onTap: onTap,
                  child: ShapeOfView(
                    shape: BubbleShape(
                        position: BubblePosition.Bottom,
                        arrowPositionPercent: 0.5,
                        borderRadius: 20,
                        arrowHeight: 10,
                        arrowWidth: 10),
                    child: Container(
                      color: color,
                      padding: const EdgeInsets.only(
                          bottom: 15, top: 5, left: 5, right: 5),
                      child: Icon(IconData(icon, fontFamily: 'MaterialIcons'),
                          size: 30.0, color: Colors.white),
                    ),
                  ),
                  // Icon(
                  //   Icons.location_history_rounded,
                  //   color: color,
                  //   size: 40,
                  // ),
                  // Container(
                  //     width: 50.0,
                  //     height: 50.0,
                  //     decoration: new BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: color,
                  //     )),
                ),
              )
            ],
          ),
        );
        markers.add(marker);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getMarkers();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _descriptionController.dispose();
  //   _titleController.dispose();
  //   _locationController.dispose();
  //   _indicatorController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //get posts from firestore
    FirebaseFirestore.instance.collection('posts').snapshots();

    //set initial marker latitude and longitude
    //working
    final initialMarker = Marker(
      width: 100.0,
      height: 55.0,
      point: LatLng(lat, long),
      builder: (BuildContext context) => Container(
        width: 100,
        child: Column(
          children: const [
            Icon(Icons.location_on, size: 40.0, color: Colors.red),
            Text('Current Location',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
    markers.add(initialMarker);

    return lat == 0 || long == 0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _file == null
            ? Scaffold(
                // appBar: AppBar(
                //   title: const Text('Flutter Map'),
                // ),
                body: Center(
                  child: Container(
                    child: Stack(
                      children: [
                        FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                                center: currentCenter, zoom: currentZoom),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://api.tomtom.com/map/1/tile/basic/main/"
                                    "{z}/{x}/{y}.png?key={apiKey}",
                                additionalOptions: {"apiKey": apiKey},
                              ),
                              MarkerLayer(markers: markers)
                            ]),
                        // Align(
                        //   alignment: Alignment.topCenter,
                        //   child: Container(
                        //     margin: const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 40),
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(0.3),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         IconButton(
                        //           onPressed: () {},
                        //           icon: const Icon(Icons.menu),
                        //           color: Colors.white,
                        //         ),
                        //         IconButton(
                        //           onPressed: () {},
                        //           icon: const Icon(Icons.search),
                        //           color: Colors.white,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white, //.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AddReportBtn(),
                                const Indicator(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            //after taking a pic
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: AppColors.white,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                      size: 20,
                    ),
                    onPressed: clearImage,
                  ),
                  title: Text('Incident Report',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        postImage(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        );
                      },
                      child: Text(
                        "Post",
                        style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.blueAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                // POST FORM
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Padding(padding: EdgeInsets.only(top: 0.0)),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'Attached Media.',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                    text: ' *',
                                    style: AppTextStyles.body
                                        .copyWith(color: Colors.red)),
                              ]),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.image_rounded,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            )),
                          ),
                        ),
                      ),
                      // ListTile(
                      //   leading: CircleAvatar(
                      //     backgroundImage: NetworkImage(
                      //       userProvider.getUser.photoUrl,
                      //     ),
                      //   ),
                      //   title: Container(
                      //     width: MediaQuery.of(context).size.width - 100,
                      //     child: TextField(
                      //       inputFormatters: [
                      //         LengthLimitingTextInputFormatter(15)
                      //       ],
                      //       controller: _titleController,
                      //       style: AppTextStyles.body,
                      //       decoration: const InputDecoration(
                      //           hintText: "Report Title",
                      //           hintStyle: AppTextStyles.body,
                      //           border: InputBorder.none),
                      //       //maxLines: 2,
                      //     ),
                      //   ),
                      // ),
                      // const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'What happened?',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' *',
                                        style: AppTextStyles.body
                                            .copyWith(color: Colors.red)),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: _incidentTitle,
                                    child: Icon(
                                      Icons.info_rounded,
                                      color: AppColors.grey,
                                      size: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15)
                                ],
                                controller: _titleController,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                    hintText: "Write the incident...",
                                    hintStyle: AppTextStyles.body.copyWith(
                                      color: AppColors.grey,
                                    ),
                                    border: InputBorder.none),
                                //maxLines: 2,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Explain what happened.',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' *',
                                        style: AppTextStyles.body
                                            .copyWith(color: Colors.red)),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: _incidentExplanation,
                                    child: Icon(
                                      Icons.description_rounded,
                                      color: AppColors.grey,
                                      size: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: _descriptionController,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                    hintText:
                                        "Write an incident description...",
                                    hintStyle: AppTextStyles.body.copyWith(
                                      color: AppColors.grey,
                                    ),
                                    border: InputBorder.none),
                                //maxLines: 8,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'What type of incident?',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' *',
                                        style: AppTextStyles.body
                                            .copyWith(color: Colors.red)),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: _incidentType,
                                    child: Icon(
                                      Icons.contact_support_rounded,
                                      color: AppColors.grey,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 45,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      'Select Report Indicator',
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    items: _indicators
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item,
                                                  style: AppTextStyles.body),
                                            ))
                                        .toList(),
                                    value: _selectedIndicator,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedIndicator = value as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 340,
                                    itemHeight: 40,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Incident Location.',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' *',
                                        style: AppTextStyles.body
                                            .copyWith(color: Colors.red)),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: _incidentLocation,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                enabled: false,
                                controller: _locationController,
                                style: AppTextStyles.body,
                                decoration: const InputDecoration(
                                  hintText: "Where was the photo taken?...",
                                  hintStyle: AppTextStyles.body,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  //widget for button
  AddReportBtn() {
    return ElevatedButton(
      onPressed: () {
        _selectImage(context);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0)),
        // backgroundColor:
        //     MaterialStateProperty.all<Color>(Colors.blueAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.blueAccent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Add Report',
          ),
        ],
      ),
    );
  }

  //show dialog for incident explantion of what happened
  Future<void> _incidentExplanation() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
            title: Text(
              'Incident Explanation',
              style: AppTextStyles.title.copyWith(
                color: AppColors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Explain what happened in the incident. Be as detailed as possible.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //shod dialog for incident location
  Future<void> _incidentLocation() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
            title: Text(
              'Incident Location',
              style: AppTextStyles.title.copyWith(
                color: AppColors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Location of the incident is automatically detected based on your current location.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //show dialog for incident title
  Future<void> _incidentTitle() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
            title: Text(
              'Incident Title',
              style: AppTextStyles.title.copyWith(
                color: AppColors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                //title limited in 15 characters
                children: <Widget>[
                  Text(
                    'Title limited in 15 characters.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //show dialog
  Future<void> _incidentType() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 30.0, right: 30, left: 30),
          title: Text(
            'Type of Incidents',
            style: AppTextStyles.title.copyWith(
              color: AppColors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CODE RED',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' - Fire and Smoke Conditions',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CODE AMBER',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' - Missing Child or Infant',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CODE BLUE',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' - Medical Emergency',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CODE GREEN',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' - Hazardous Conditions',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CODE BLACK',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' - Weather Warning',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
