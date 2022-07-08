import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/spaki.gif'),
                  // backgroundColor: Colors.white,
                ),
                accountName: Text('Account'),
                accountEmail: Text('Email@gmail.com'),
                onDetailsPressed:(){
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Colors.grey[850]),
              title: Text('Settings'),
              onTap:(){
                print('Setting is clicked');
              },
              trailing: Icon(Icons.add),
            ),
          ],
        )
    );
  }
}