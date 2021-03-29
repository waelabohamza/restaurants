import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DeliveryList extends StatelessWidget {
  final listusers;
  DeliveryList({this.listusers});
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {},
        child: Card(
            child: Row(
          children: [
            Expanded(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: listusers['user_image'] == null ||
                        listusers['user_image'] == ""
                    ? CachedNetworkImageProvider(
                        "${crud.server}/upload/users/avatar.png")
                    : CachedNetworkImageProvider(
                        "${crud.server}/upload/users/${listusers['user_image']}"),
              ),
              flex: 2,
            ),
            Expanded(
              child: ListTile(
                title: Text(" ${listusers['username']} "),
                subtitle: Text(" ${listusers['email']} "),
              ),
              flex: 3,
            ),
          ],
        )),
      ),
    );
  }
}
