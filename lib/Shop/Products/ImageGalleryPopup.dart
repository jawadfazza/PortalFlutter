import 'package:flutter/material.dart';
class ImageGalleryPopup extends StatefulWidget {
  final List<String> images;

  ImageGalleryPopup({required this.images});

  @override
  _ImageGalleryPopupState createState() => _ImageGalleryPopupState();
}

class _ImageGalleryPopupState extends State<ImageGalleryPopup> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
            child: PageView.builder(
              itemCount: widget.images.length,
              controller: PageController(initialPage: _currentIndex),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _currentIndex == index ? 12 : 8,
                  height: 20,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


