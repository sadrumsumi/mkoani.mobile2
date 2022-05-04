import 'dart:io';

import 'package:Mkoani/blocs/bloc.dart';

import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart' as models;
import 'package:Mkoani/requests/profile.dart';

import 'package:Mkoani/requests/upload.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../requests/requests.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../components.dart';

class Profile extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: models.MyPages.profile,
        key: ValueKey(models.MyPages.profile),
        child: Profile());
  }

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _photo;
  final ImagePicker _picker = ImagePicker();
  late Future<models.Profile> profile;
  XFile? _file;
  Stream<XFile>? streamFile;

  Future<XFile?> takePicture({required ImageSource source}) async {
    XFile? file = await _picker.pickImage(
      source: source,
    );
    return file;
  }

  @override
  void initState() {
    String cookie =
        BlocProvider.of<AppBloc>(context, listen: false).app.user!.cookie!;
    profile = getProfile(cookie: cookie);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppBloc appStateManager =
        BlocProvider.of<AppBloc>(context, listen: false);
    final Auth auth = BlocProvider.of<Auth>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white)))),
            preferredSize: Size(double.infinity, 8)),
        actions: [
          PopUpMenu(
            appStateManager: appStateManager,
            auth: auth,
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<models.Profile>(
            future: profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('$snapshot.data'),
                  );
                } else {
                  models.Profile profile = snapshot.data!;
                  _photo = '${Requests.static}${profile.profilePic}';
                  return Center(
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Stack(children: [
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      )),
                                  CircleAvatar(
                                    child: profile.profilePic.isNotEmpty &&
                                            streamFile == null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              _photo!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : StreamBuilder<XFile>(
                                            stream: streamFile,
                                            builder: (context, snapshot) {
                                              print('||||****(KJ');
                                              if (snapshot.hasData) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.file(
                                                    File(snapshot.data!.path),
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Placeholder();
                                              } else {
                                                return const Icon(
                                                  Icons.person,
                                                  size: 60,
                                                );
                                              }
                                            }),
                                    radius: 50,
                                  ),
                                ]),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContainer(profile.firstName),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContainer(profile.lastName),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContainer(profile.phone),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContainer(profile.email),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContainer(profile.roles[0]),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // navigate to edit screen

                                  appStateManager.add(OnAddPage(
                                      page: UpdateProfile.page(),
                                      app: appStateManager.app));
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        const Color(0xF2B705)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 18))),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  // navigate to change password
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: ChangePassword(),
                                        );
                                      });
                                },
                                child: const Text('Change password?'),
                              ),
                            ],
                          )),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    ));
  }

  Container buildContainer(String value) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        value,
        style: const TextStyle(color: Colors.black),
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2.0),
          shape: BoxShape.rectangle),
    );
  }

  void _processPhoto(AppBloc appStateManager, ImageSource source) async {
    Navigator.of(context).pop();
    XFile? file = await takePicture(source: source);
    if (file != null) {
      appStateManager.add(OnLoading(appStateManager.app));
      streamFile = Stream.value(file);
      setState(() {});

      try {
        String response =
            await upload(file: file, cookie: appStateManager.app.user!.cookie!);

        appStateManager.add(OnLoadingComplete(appStateManager.app));
        showSnackbar(context, response);
      } on NetworkException catch (e) {
        showSnackbar(context, e.toString());
      }
    }
  }
}
