import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:handle_permissions/constants/image_section.dart';
import 'package:permission_handler/permission_handler.dart';
import './home_controller.dart';

class HomePage extends GetView<HomeController> with WidgetsBindingObserver {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FilePicker x GetX'),
      ),
      body: Obx(() {
        switch (controller.imageSection) {
          case ImageSection.noStorePermission:
            return _ImagePermissions(
              isPermanent: false,
              onPressed: _checkPermissionsAndPick,
            );
          case ImageSection.noStorePermissionPerminent:
            return _ImagePermissions(
              isPermanent: true,
              onPressed: _checkPermissionsAndPick,
            );
          case ImageSection.browsFile:
            return _PickFile(
              onPressed: _checkPermissionsAndPick,
            );
          case ImageSection.imageLoaded:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ImageLoaded(
                  file: controller.file!,
                ),
                _PickFile(onPressed: _checkPermissionsAndPick)
              ],
            );
          default:
            return Container();
        }
      }),
    );
  }

  Future<void> _checkPermissionsAndPick() async {
    final hasFilePermissions = await controller.requestPermission();
    if (hasFilePermissions) {
      try {
        await controller.pickFile();
      } catch (e) {
        debugPrint('Error when picking a file :$e');
        Get.showSnackbar(const GetSnackBar(
          message: 'An error occurred when picking a file.',
        ));
      }
    }
  }
}

class _ImagePermissions extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onPressed;

  const _ImagePermissions({
    Key? key,
    required this.isPermanent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 24.0,
            right: 16.0,
          ),
          child: Text(
            'Read files permissions',
            style: Get.textTheme.headline4,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 24.0,
                    right: 16.0,
                  ),
                  child: const Text(
                    'We need to request your permissions to read '
                    'local files in order to load them into the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
                if (isPermanent)
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 24.0,
                      right: 16.0,
                    ),
                    child: const Text(
                      'You need to give this permission from the system setting.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 24.0,
                    right: 16.0,
                  ),
                  child: ElevatedButton(
                    child: Text(isPermanent ? 'Open settting' : 'Allow access'),
                    onPressed: () => isPermanent ? openAppSettings() : onPressed(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PickFile extends StatelessWidget {
  final VoidCallback onPressed;
  const _PickFile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Pick file'),
        onPressed: onPressed,
      ),
    );
  }
}

class _ImageLoaded extends StatelessWidget {
  final File file;
  const _ImageLoaded({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 196.0,
        height: 196.0,
        child: ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
