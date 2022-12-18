import 'package:dd_study_22_ui/ui/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy HH:mm");
    var viewModel = context.watch<ProfileViewModel>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: viewModel.user == null
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        viewModel.avatar == null
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: viewModel.changePhoto,
                                child: CircleAvatar(
                                  radius: size.width / 1.5 / 2,
                                  foregroundImage: viewModel.avatar?.image,
                                )),
                        Text(
                          viewModel.user!.name,
                          style: const TextStyle(fontSize: 40),
                        ),
                        Text(
                          viewModel.user!.email,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          dtf.format(viewModel.user!.birthDate),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ]),
          ),
        ));
  }

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: bc);
      },
      child: const ProfileWidget(),
    );
  }
}
