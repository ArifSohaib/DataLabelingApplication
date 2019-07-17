import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'Views/home_material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Teamato Data Label",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{

  @override
  State createState() {
     return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage>{

  File _imageFile;
  bool _uploaded = false;
  String _downloadUrl;
  String _image_label;
  StorageReference _reference = FirebaseStorage.instance.ref().child('${DateTime.now()}.jpg');

  Future getImage(bool isCamera) async{
    File image;
    if(isCamera){
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    else{
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async{
    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
  }

  Future downloadImage() async{
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  Future uploadLabel(String label) async{
    setState(() {
      _image_label = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teamato Data Label"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("Camera"),

                onPressed: (){
                  getImage(true);
                },
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                child: Text("Gallery"),
                onPressed: (){
                  getImage(false);
                },
              ),
              _imageFile == null ? Container(): Image.file(_imageFile, height: 300.0, width: 300.0,),
              _imageFile == null ? Container(): RaisedButton(
                child: Text("Upload To Firebase"),
                onPressed: (){
                  uploadImage();
                },
              ),
              _uploaded == false ? Container():RaisedButton(
                child: Text("Download image"),
                onPressed: (){
                  downloadImage();
                },
              ),
              Column(
                children: <Widget>[
                  _uploaded == false ? Container():TextField(

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Image Label",
                    ),

                  ),
                  _uploaded == false ? Container(): RaisedButton(
                    splashColor: Colors.green,
                    onPressed: (){

                    },
                  ),
                ],
              ),
              _downloadUrl == null ? Container(): Image.network(_downloadUrl, height: 300.0, width: 300.0,),

            ],
          ),
        ),
      ),
    );
  }
}