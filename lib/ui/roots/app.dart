import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/data_service.dart';
import '../app_navigator.dart';

class _ViewModel extends ChangeNotifier {
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

  _ViewModel({required this.context}) {
    asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(Duration(seconds: 1)).then((value) {
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

    await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void obclick() {
    var offset = _lvc.offset;

    _lvc.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeInCubic);
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.posts?.length ?? 0;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.obclick,
          child: Icon(Icons.arrow_circle_up_outlined),
        ),
        appBar: AppBar(
          leading: (viewModel.user != null)
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    "$baseUrl${viewModel.user!.avatarLink}",
                  ),
                )
              : null,
          title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
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
      create: (BuildContext context) => _ViewModel(context: context),
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
