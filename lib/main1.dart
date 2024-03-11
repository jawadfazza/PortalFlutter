import 'package:flutter/material.dart';

void  main() {
  runApp(MyApp(items: List<ListItem>.generate(100, (index) {
   return  index % 6== 0 ?
    HeaderItem("Header Item $index")
    : MessageItem('Sender $index', 'Message body $index');
  })));
}

class MyApp extends StatelessWidget{
  final List<ListItem> items;

  const MyApp({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title :"Grouping List",
      home: Scaffold(
        body: ListView.builder(itemBuilder: (context, index) {

          final item= items[index];
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubTitle(context),
          );
        },
          itemCount: items.length,),

      ),

    );
  }

}


abstract class ListItem{

  Widget buildTitle(BuildContext context) ;

  Widget buildSubTitle(BuildContext context);
}

class HeaderItem implements ListItem{
  final String heading;
  HeaderItem(this.heading);

  @override
  Widget buildSubTitle(BuildContext context) {
    // TODO: implement buildSubTitle
    return Text(heading,
    style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    // TODO: implement buildTitle
    return const SizedBox.shrink();
  }

}

class MessageItem implements ListItem{
  final String sender;
  final String body;
  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) {
    // TODO: implement buildTitle
    return Text(sender,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
  @override
  Widget buildSubTitle(BuildContext context) {
    // TODO: implement buildSubTitle
    return Text(body,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}