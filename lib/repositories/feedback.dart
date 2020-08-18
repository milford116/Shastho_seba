import '../networking/api.dart';

class FeedbackRepository {
  Api _api = Api();

  Future<void> postFeedback(String feedback) async {
    await _api.post('/patient/post/feedback', true, {'feedback': feedback});
  }
}
