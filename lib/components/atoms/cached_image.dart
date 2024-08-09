import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:peeker/components/atoms/custom_circular_progress_indicator.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    required this.url,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  final String url;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(url),
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? event) {
        if (event == null) {
          return child;
        }
        return Center(
          child: Container(
            padding: padding,
            child: CustomCircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!),
          ),
        );
      },
    );
  }
}
