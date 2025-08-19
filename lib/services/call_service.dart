import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  Future<String> startCall(String receiverId) async {
    if (await Permission.microphone.request().isGranted) {
      final callId = DateTime.now().millisecondsSinceEpoch.toString();
      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          // Add TURN server if needed
        ]
      };
      _peerConnection = await createPeerConnection(configuration);

      // Get local audio stream
      _localStream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': false});
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      // Create offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      await _firestore.collection('calls').doc(callId).set({
        'callerId': FirebaseAuth.instance.currentUser!.uid,
        'receiverId': receiverId,
        'offer': {'sdp': offer.sdp, 'type': offer.type},
        'status': 'pending',
      });

      // Handle ICE candidates
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        _firestore.collection('calls').doc(callId).collection('callerCandidates').add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      };

      return callId;
    }
    return '';
  }

  Future<void> joinCall(String callId, Function(MediaStream) onRemoteStream) async {
    if (await Permission.microphone.request().isGranted) {
      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ]
      };
      _peerConnection = await createPeerConnection(configuration);
      _localStream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': false});
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      final callDoc = _firestore.collection('calls').doc(callId);
      final callData = (await callDoc.get()).data()!;
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(callData['offer']['sdp'], callData['offer']['type']),
      );

      // Create answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      await callDoc.update({
        'answer': {'sdp': answer.sdp, 'type': answer.type},
        'status': 'accepted',
      });

      // Handle ICE candidates for receiver
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        callDoc.collection('receiverCandidates').add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      };

      // Listen for caller ICE candidates
      callDoc.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            _peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });

      // Listen for receiver ICE candidates on caller side
      callDoc.collection('receiverCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            _peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });

      // Handle remote stream
      _peerConnection!.onAddStream = (stream) {
        onRemoteStream(stream);
      };
    }
  }

  Future<void> endCall(String callId) async {
    await _firestore.collection('calls').doc(callId).update({'status': 'ended'});
    _localStream?.getTracks().forEach((track) => track.stop());
    await _peerConnection?.close();
    _peerConnection = null;
    _localStream = null;
  }
}