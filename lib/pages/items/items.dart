import 'package:flutter/material.dart';
import 'package:restaurants/pages/items/edititems.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../component/crud.dart';

class Items extends StatefulWidget {
  Items({Key key}) : super(key: key);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Crud crud = new Crud();

  Future deleteItem(String id, String imagename) async {
    var data = {"itemid": id, "imagename": imagename};
    await crud.writeData("deleteitems", data);
  }

  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;
    Map route = ModalRoute.of(context).settings.arguments;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("الوجبات"),
          ),
          // drawer: MyDrawer(),
          floatingActionButton: Container(
              padding: EdgeInsets.only(left: mdw - 100),
              child: Container(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('additems');
                    },
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ),
                    backgroundColor: Colors.red,
                  ))),
          body: WillPopScope(
              child: FutureBuilder(
                future: crud.readDataWhere("items", route['resid']),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        // print(snapshot.data[i]['item_image']);
                        if (snapshot.data[0] == "faild") {
                          return Center(
                              child: Text(
                            "لا يوجد اي وجبة مضافة ",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ));
                        }
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            child: Center(
                                child: Text("حذف نهائي",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white))),
                          ),
                          // secondaryBackground: Text("DELETE" , style: TextStyle(fontSize: 40 , color: Colors.black),),
                          child: ItemsList(
                            id: snapshot.data[i]['item_id'],
                            name: snapshot.data[i]['item_name'],
                            nameen: snapshot.data[i]['item_name_en'],
                            price: snapshot.data[i]['item_price'],
                            itemcat: snapshot.data[i]['cat_name'],
                            image: snapshot.data[i]['item_image'],
                            itemcatid: snapshot.data[i]['cat_id'],
                            itemsdesc: snapshot.data[i]['item_description'],
                            
                          ),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await deleteItem(snapshot.data[i]['item_id'],
                                  snapshot.data[i]['item_image']);
                              setState(() {
                                snapshot.data.removeAt(i);
                              });
                            }
                          },
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              onWillPop: () {
                Navigator.of(context).pushNamed("home");
                return;
              }),
        ));
  }
}

class ItemsList extends StatelessWidget {
  Crud crud = new Crud();
  final itemsdesc ; 
  final id;
  final name;
  final nameen;
  final price;
  final itemcat;
  final image;
  final itemcatid;
  ItemsList(
      {this.id,
      this.name,
      this.nameen,
      this.price,
      this.itemcat,
      this.image,
      this.itemcatid , 
      this.itemsdesc
      });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditItem(
              itemid: id,
              itemcat: itemcat,
              itemname: name,
              itemnameen: nameen,
              itemprice: price,
              item_catid: itemcatid,
              image: image , 
              itemsdesc: itemsdesc
              );
        }));
      },
      child: Container(
          child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                imageUrl: "${crud.server}/upload/items/$image",
                progressIndicatorBuilder: (context, url, downloadProgress)
                 => CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 4,
              child: ListTile(
                title: Text("${name}"),
                trailing: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    "${price}  KD  ",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                subtitle: Text("${itemcat}"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
