import 'package:dd_study_22_ui/domain/models/post.dart';
import '../../internal/dependencies/repository_module.dart';
import 'data_service.dart';

class SyncService {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  Future syncPosts() async {
    var postModels = await _api.getPosts(0, 100);
    var authors = postModels.map((e) => e.author).toSet();

    var postContents = postModels
        .expand((x) => x.contents.map((e) => e.copyWith(postId: x.id)))
        .toList();
    var posts = postModels
        .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id))
        .toList();

    await _dataService.rangeUpdateEntities(authors);
    await _dataService.rangeUpdateEntities(posts);
    await _dataService.rangeUpdateEntities(postContents);
  }
}
