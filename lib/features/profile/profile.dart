import 'package:data_table_try/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_MV.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileMV>(context, listen: false).getUserInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ProfileMV>(builder: (context, data, child) {
                return (data.user == null)
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Avatar(),
                          const UserInfo(),
                          CustomProfileButton(
                            text: 'تغيير كلمة المرور',
                            onPress: () {
                              data.showPasswordForm(context);
                            },
                            color: Colors.deepPurple,
                          ),
                          CustomProfileButton(
                            text: 'تسجيل الخروج',
                            onPress: () {
                              data.logout(context);
                            },
                            color: Colors.redAccent,
                          )
                        ],
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileMV>(
      builder: (context, data, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              data.user!.name!,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Text(
              data.user!.userName!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'Role: ${data.user?.role!.value}',
            style: const TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.deepPurple,
        maxRadius: 141,
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          maxRadius: 140,
          child: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            maxRadius: 121,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              maxRadius: 120,
              child: Consumer<ProfileMV>(
                builder: (context, data, child) => Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      maxRadius: 100,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        maxRadius: 97,
                        backgroundImage:
                            const AssetImage('assets/images/user-128.png'),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(60)),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                      onTap: () async {
                        // XFile? image = await picker.pickImage(
                        //     source: ImageSource.gallery);
                        // if (image == null) return;
                        // final imageTemp = XFile(image.path);
                        // setState(() => photo = imageTemp);
                        // print(photo?.path);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProfileButton extends StatelessWidget {
  const CustomProfileButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.color = Colors.lightBlueAccent});

  final String text;
  final Function() onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        width: Responsive.widthOfScreen(context: context, width: .7),
        child: ElevatedButton(
          onPressed: onPress,
          style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(5),
              backgroundColor: MaterialStatePropertyAll(color)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
