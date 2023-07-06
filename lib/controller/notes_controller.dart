import 'dart:io';
import 'package:easy_certs/repository/notes_repo.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

class NotesController extends GetxController implements GetxService {
  // Object of Image Picker
  final ImagePicker _picker = ImagePicker();
  // Will Assign Image to this variable
  File? pickedImageAsFile;

  // Pick Image from gallery
  Future<File?> pickImageFromGallery() async {
    XFile? pickedImageXFileFromGallery = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    // Get.back();

    pickedImageAsFile = File(pickedImageXFileFromGallery!.path);
    update();
    return pickedImageAsFile;
  }

  Future<dynamic> uploadNotesImage({
    required String jobId,
    required String notes,
    required String token,
  }) async {
    dynamic check = await NotesRepo().uploadImageOfNotes(
      jobId: jobId,
      notes: notes,
      token: token,
      type: 8,
    );
    if (check != null) {
      devtools.log(check.toString());
      Get.find<NotesController>().pickedImageAsFile = null;
    }
    if (check != null && check["data"] != null) {
      // devtools.log(check.toString());
      Get.find<NotesController>().pickedImageAsFile = null;
      Get.back();
      Util.showSnackBar(
        "Note",
        "Image Uploaded Successfully!",
        "",
      );
    } else {
      Util.showErrorSnackBar(
        "Something Went Wrong",
      );
    }

    return check;
  }

  // Upload Text Note
  Future<dynamic> uploadTextNote({
    required String jobId,
    required String note,
    required String token,
    required int type,
  }) async {
    Util.showLoading("Uploading...");
    final check = await NotesRepo().uploadTextNote(
      note: note,
      token: token,
      jobId: jobId,
      type: 7,
    );
    Util.dismiss();
    if (check != null && check["data"] != null) {
      Get.back();
      Util.showSnackBar(
        "Note",
        "Note Uploaded Successfully!",
        "",
      );
    } else {
      Util.showErrorSnackBar(
        "Something Went Wrong",
      );
    }

    return check;
  }

  // Upload Notes Signature
  Future<dynamic> uploadSignatureOfNote({
    required String jobId,
    required String token,
    required int type,
    required File imageFile,
  }) async {
    dynamic check = await NotesRepo().uploadSignatureOfNotes(
      jobId: jobId,
      token: token,
      type: type,
      imageFile: imageFile,
    );
    devtools.log(check.toString());
    if (check != null && check["data"] != null) {
      Get.back();
      Util.showSnackBar(
        "Note",
        "Signature Uploaded Successfully!",
        "",
      );
    } else {
      Util.showErrorSnackBar(
        "Something Went Wrong",
      );
    }
    return check;
  }
}
