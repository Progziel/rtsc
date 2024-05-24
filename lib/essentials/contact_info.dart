import 'package:app/helper/colors.dart';
import 'package:flutter/material.dart';

class MyContactInfo extends StatelessWidget {
  const MyContactInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColorHelper.black1.withOpacity(0.25),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.email_rounded, size: 20),
              SizedBox(width: 8.0),
              Text(
                'Email: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                'info@rtsc.live',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phone_rounded, size: 20),
              SizedBox(width: 8.0),
              Text(
                'Phone: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                '+1 914-629-3937',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.apartment_rounded, size: 20.0),
              SizedBox(width: 8.0),
              Text(
                'Office: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  '5 Tudor City Pl Apt 1616 New York, NY 10017 United States',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
