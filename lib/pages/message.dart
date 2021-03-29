import 'package:flutter/material.dart';
import 'package:restaurants/component/crud.dart';
import 'package:restaurants/main.dart';
import 'package:jiffy/jiffy.dart';

class Message extends StatefulWidget {

  Message({Key key}) : super(key: key);
  @override
  _MessageState createState() => _MessageState();

}

class _MessageState extends State<Message> {
  var userid = sharedPrefs.getString("id");
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('الاشعارات'),
          ),
          body: WillPopScope(child: Container(
            child: FutureBuilder(
              future: crud.readDataWhere("messages", userid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data[0] == "faild") {
                    return Center(child: Text("لا يوجد اي رسائل"));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return MessagesList(
                          title: snapshot.data[i]['message_title'],
                          body: snapshot.data[i]['message_body'],
                          time: snapshot.data[i]['message_time'],
                        );
                      });
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ), onWillPop: (){
            Navigator.of(context).pushNamed("home") ; 
            return ; 
          })
        ));
  }
}

class MessagesList extends StatelessWidget {
  final title;
  final body;
  final time;
  const MessagesList({Key key, this.body, this.time, this.title})
      : super(key: key);  
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title"),
          Text("${Jiffy(time).fromNow()}", style: TextStyle(color: Colors.red , fontSize: 12))
        ],
      ),
      subtitle: Text(
          "$body"),
    )) ,
    Divider()
    ]);
  }
}
