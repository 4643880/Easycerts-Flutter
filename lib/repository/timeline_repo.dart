import 'package:easy_certs/helper/api.dart';

class TimelineRepo {
  Future<dynamic> postWorkedTime({
    required String id,
    required int duration,
  }) async {
    Uri uri = Uri.parse("${ApiHelper.getApiUrls()[ApiHelper.kWorkedTime]}");
    dynamic dynamicData = ApiHelper().post(
      "worked time api in timeline repo",
      uri,
      ApiHelper.getAuthHeader(),
      {
        "id": id,
        "duration": duration,
      },
    );
    return dynamicData;
  }
}
