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
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                child: PageView.builder(
                  itemCount: itemData.imagePaths.isEmpty
                      ? 1
                      : itemData.imagePaths.length,
                  controller: PageController(
                    viewportFraction: 0.8,
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int horizontalIndex,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: itemData.imagePaths.isEmpty
                            ? Image.asset(
                                'assets/images/noimage.png',
                                fit: BoxFit.fitHeight,
                              )
                            : Image.file(
                                File(itemData.imagePaths[horizontalIndex]),
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                height: MediaQuery.of(context).size.height * 0.05,
                child: Text(
                  itemData.item.name == 'null' ? '' : itemData.item.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }
}
