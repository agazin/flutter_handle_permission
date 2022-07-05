import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:handle_permissions/constants/image_section.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final Rx<ImageSection> _imageSection = Rx<ImageSection>(ImageSection.noStorePermission);
  final Rxn<File> _file = Rxn<File>();
  final RxBool _detectPermission = false.obs;

  ImageSection get imageSection => _imageSection.value;
  set imageSection(imageSection) => _imageSection.value = imageSection;

  File? get file => _file.value;
  set file(file) => _file.value = file;

  bool get detectPermission => _detectPermission.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState : ${state.name}');
    if (state == AppLifecycleState.resumed 
          && detectPermission && imageSection == ImageSection.noStorePermissionPerminent) {
      _detectPermission.value = false;
      requestPermission();
    } else if (state == AppLifecycleState.paused 
        && imageSection == ImageSection.noStorePermissionPerminent) {
      _detectPermission.value = true;
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = await Permission.storage.request();
    } else {
      result = await Permission.photos.request();
    }
    if (result.isGranted) {
      _imageSection.value = ImageSection.browsFile;
      return true;
    } else if (Platform.isIOS || result.isPermanentlyDenied) {
      imageSection = ImageSection.noStorePermissionPerminent;
    } else {
      imageSection = ImageSection.noStorePermission;
    }
    return false;
  }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
      file = File(result.files.single.path!);
      _imageSection.value = ImageSection.imageLoaded;
    }
  }
}
