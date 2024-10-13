import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:zoomout/resources/auth_methods.dart';
import 'package:zoomout/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }

      // Configure meeting options
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        userDisplayName: name,
        userEmail: _authMethods.user.email,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
      );

      // Record meeting history
      _firestoreMethods.addToMeetingHistory(roomName);

      // Join the meeting
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () {
            print("JitsiMeetingListener: onOpened");
          },
          onConferenceWillJoin: (url) {
            print("JitsiMeetingListener: onConferenceWillJoin with url: $url");
          },
          onConferenceJoined: (url) {
            print("JitsiMeetingListener: onConferenceJoined with url: $url");
          },
          onConferenceTerminated: (url, error) {
            print("JitsiMeetingListener: onConferenceTerminated with url: $url and error: $error");
          },
          
        ),
      );
    } catch (error) {
      print("Error: $error");
    }
  }
}
