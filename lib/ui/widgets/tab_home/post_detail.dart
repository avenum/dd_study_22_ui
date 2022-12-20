import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final String? postId;
  _ViewModel({required this.context, this.postId});
}

class PostDetail extends StatelessWidget {
  const PostDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Text(viewModel.postId ?? "empty"),
        ));
  }

  static create(Object? arg) {
    String? postId;
    if (arg != null && arg is String) postId = arg;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          _ViewModel(context: context, postId: postId),
      child: const PostDetail(),
    );
  }
}
