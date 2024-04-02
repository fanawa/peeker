import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idz/pages/home/models.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    Key? key,
    required this.itemData,
    this.onTap,
  }) : super(key: key);

  final ItemData itemData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  itemCount: 1, // TODO(a): listにしたい
                  controller: PageController(
                    viewportFraction: 0.8,
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int horizontalIndex,
                  ) {
                    return Container(
                      height: 100,
                      width: 120,
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: itemData.item.fileName == null ||
                              itemData.item.fileName == ''
                          ? Image.asset(
                              'assets/images/noimage.png',
                              fit: BoxFit.fitHeight,
                            )
                          : Image.file(
                              File(itemData.imagePath!),
                              fit: BoxFit.fitHeight,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                child: Text(
                  itemData.item.name == 'null' ? '' : itemData.item.name!,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
