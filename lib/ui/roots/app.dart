//import 'package:dd_study_22_ui/data/services/sync_service.dart';
//import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/ui/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/data_service.dart';
import '../app_navigator.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();
  final _lvc = ScrollController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  AppViewModel({required this.context}) {
    asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            posts = <PostModel>[...posts!, ...posts!];
            isLoading = false;
          });
        }
      }
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
        .load("$baseUrl${user!.avatarLink}?v=1");
    avatar = Image.memory(
      img.buffer.asUint8List(),
      fit: BoxFit.fill,
    );

    //await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void obclick() {
    //var offset = _lvc.offset;

    _lvc.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  }

  void toProfile(BuildContext bc) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => ProfileWidget.create(bc)));
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.posts?.length ?? 0;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.obclick,
          child: const Icon(Icons.arrow_circle_up_outlined),
        ),
        appBar: AppBar(
          leading: (viewModel.avatar != null)
              ? CircleAvatar(
                  backgroundImage: viewModel.avatar?.image,
                )
              : null,
          title: GestureDetector(
              onTap: () => viewModel.toProfile(context),
              child:
                  Text(viewModel.user == null ? "Hi" : viewModel.user!.name)),
          actions: [
            IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: viewModel._logout),
          ],
        ),
        body: Container(
            child: viewModel.posts == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                          child: ListView.separated(
                        controller: viewModel._lvc,
                        itemBuilder: (listContext, listIndex) {
                          Widget res;
                          var posts = viewModel.posts;
                          if (posts != null) {
                            var post = posts[listIndex];
                            res = Container(
                              padding: const EdgeInsets.all(10),
                              height: size.width,
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      onPageChanged: (value) => viewModel
                                          .onPageChanged(listIndex, value),
                                      itemCount: post.contents.length,
                                      itemBuilder: (pageContext, pageIndex) =>
                                          Container(
                                        color: Colors.yellow,
                                        child: Image(
                                            image: NetworkImage(
                                          "$baseUrl${post.contents[pageIndex].contentLink}",
                                        )),
                                      ),
                                    ),
                                  ),
                                  PageIndicator(
                                    count: post.contents.length,
                                    current: viewModel.pager[listIndex],
                                  ),
                                  Text(post.description ?? "")
                                ],
                              ),
                            );
                          } else {
                            res = const SizedBox.shrink();
                          }
                          return res;
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: itemCount,
                      )),
                      if (viewModel.isLoading) const LinearProgressIndicator()
                    ],
                  )));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
      child: const App(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}
