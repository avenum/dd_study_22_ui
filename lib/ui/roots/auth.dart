import 'package:dd_study_22_ui/data/auth_service.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  const _ViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
  });

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();

  BuildContext context;
  _ViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false);
  }

  void login() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 2))
        .then((value) => {state = state.copyWith(isLoading: false)});

    await _authService
        .auth(state.login, state.password)
        .then((value) => AppNavigator.toLoader());
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: viewModel.loginTec,
                  decoration: InputDecoration(hintText: "Enter Login"),
                ),
                TextField(
                    controller: viewModel.passwTec,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter Password")),
                ElevatedButton(
                    onPressed: viewModel.checkFields() ? viewModel.login : null,
                    child: Text("Login")),
                if (viewModel.state.isLoading) CircularProgressIndicator(),
              ],
            )),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Auth(),
      );
}
