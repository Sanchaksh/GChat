import 'package:flutter/material.dart';
import 'package:g_chat/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  Container(
                    height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]
                        ),
                            borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/images/search_white.png")
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
