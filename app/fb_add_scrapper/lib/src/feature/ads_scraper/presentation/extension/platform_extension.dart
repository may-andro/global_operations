import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension PlatformExtension on String? {
  String? get platformLabel {
    switch (this) {
      case 'facebook':
        return 'Facebook';
      case 'instagram':
        return 'Instagram';
      case 'audience_network':
        return 'Audience Network';
      case 'messenger':
        return 'Messenger';
      default:
        return null;
    }
  }

  IconData? get platformIcon {
    switch (this?.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'audience_network':
        return FontAwesomeIcons.networkWired;
      case 'messenger':
        return FontAwesomeIcons.facebookMessenger;
      case 'threads':
        return FontAwesomeIcons.threads;
      default:
        return null;
    }
  }
}
