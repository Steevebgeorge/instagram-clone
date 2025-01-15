import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constants/utils.dart';
import 'package:instagram/models/usermodel.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/services/firestore_methods.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController postCaptionController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Add a photo"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(15),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await getImage(ImageSource.camera);
                setState(() {
                  _image = file;
                });
              },
              child: const Text("Take a photo"),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(15),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await getImage(ImageSource.gallery);
                setState(() {
                  _image = file;
                });
              },
              child: const Text("Choose from gallery"),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(15),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void postImage(String uid, String userName, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _image!, postCaptionController.text, uid, userName, profileImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          customSnackBar(context, 'Posted successfully');
          clearImage();
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          customSnackBar(context, res.toString());
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        customSnackBar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    postCaptionController.dispose();
    super.dispose();
  }

  void clearImage() {
    setState(() {
      _image = null;
      postCaptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    if (_image == null) {
      return Center(
        child: IconButton(
          onPressed: () => _selectImage(context),
          icon: const Icon(Icons.upload),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: clearImage,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("post to"),
        actions: [
          TextButton(
            onPressed: () => postImage(user!.uid, user.userName, user.photoUrl),
            child: const Text(
              "post",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading)
              const LinearProgressIndicator()
            else
              const Padding(padding: EdgeInsets.only(top: 0)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoUrl),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: postCaptionController,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_image!),
                          fit: BoxFit.cover,
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
}
