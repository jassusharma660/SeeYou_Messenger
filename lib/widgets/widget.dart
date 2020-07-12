import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return SafeArea(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Image.asset("assets/images/logo.png", width: 150,),
    ),
  );
}

Widget appBarSecondary({BuildContext context, String title, bool raised = false, Color backgroundColor = Colors.transparent}) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          color: raised ? Color(0x11888888) : Colors.transparent,
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    margin: EdgeInsets.only(top: 20),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_back, size: 30,)
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget formInput({BuildContext context, final onTap, final validator, TextEditingController controller,
                  String iconUrl, String label, String hint, bool obscureText = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x10000000),
              blurRadius: 5.0,
              spreadRadius: 5.0
          ),
        ],
        color: Color(0xbbffffff),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 95,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(iconUrl, height: 35),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 30,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0x55000000),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 257,
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  validator: validator,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                    isDense: true,
                    hintText: hint,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                        width: 0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget formButton({BuildContext context, final onTap, String btnLabel, Color btnColor, Color btnLabelColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x10000000),
              blurRadius: 5.0,
              spreadRadius: 5.0
          ),
        ],
        color: btnColor,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Text(
        btnLabel,
        style: TextStyle(
          color: btnLabelColor,
          fontSize: 13,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
}