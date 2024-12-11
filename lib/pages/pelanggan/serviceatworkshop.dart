import 'package:flutter/material.dart';

class ServiceAtWorkshopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Servis di Bengkel',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text('Maps bengkel terdekat'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Bengkel Ajwa'),
                          subtitle: Text('Jl. Telekomunikasi No. 203, Bandung'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Tambal Ban Sukapura'),
                          subtitle: Text('Jl. Sukapura No. 69, Bandung'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Bengkel Jaya Motor'),
                          subtitle: Text('Jl. Raya Bojongsoang No. 50, Bandung'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}