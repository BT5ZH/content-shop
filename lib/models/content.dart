import 'package:flutter/material.dart';

import './location_data.dart';

class Content {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String imagePath;
  // final String coverImagePath;
  // final int episodeCount;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  final LocationDataModel location;

  Content(
      {
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.imagePath,
      // @required this.coverImagePath,
      // @required this.episodeCount,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      this.isFavorite=false,
      });

      
}
