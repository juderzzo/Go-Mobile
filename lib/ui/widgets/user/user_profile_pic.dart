import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:shimmer/shimmer.dart';

class UserProfilePic extends StatelessWidget {
  final String userPicUrl;
  final double size;

  UserProfilePic({
    this.userPicUrl,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: userPicUrl,
          filterQuality: FilterQuality.medium,
          placeholder: (context, url) => Container(
            height: size,
            width: size,
            child: Shimmer.fromColors(
                baseColor: CustomColors.iosOffWhite,
                highlightColor: Colors.white70,
                child: Container(
                  height: size,
                  width: size,
                  color: Colors.white,
                )),
          ),
          errorWidget: (
            context,
            url,
            error,
          ) =>
              Icon(
            FontAwesomeIcons.user,
            color: Colors.black12,
          ),
          useOldImageOnUrlChange: false,
        ),
      ),
    );
  }
}
