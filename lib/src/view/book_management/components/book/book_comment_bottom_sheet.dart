import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/firebase/comment_api.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/comment.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/single_user_service.dart';
import 'package:htlib/styles.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:uuid/uuid.dart';

class BookCommentBottomSheet extends StatefulWidget {
  const BookCommentBottomSheet({Key? key, required this.book})
      : super(key: key);
  final Book book;

  @override
  State<BookCommentBottomSheet> createState() => _BookCommentBottomSheetState();
}

class _BookCommentBottomSheetState extends State<BookCommentBottomSheet> {
  late FirebaseBookCommentApi _api = FirebaseBookCommentApi(widget.book.id!);
  TextEditingController _commentController = TextEditingController();

  SingleUserService? _userService;
  AdminService? _adminService;

  bool _isMineComment(Comment comment) {
    if (_isLibrarian()) return true;
    if (_userService != null) return comment.senderId == _userService!.user.id;
    if (_adminService != null)
      return comment.senderId == _adminService!.currentUser.value.uid;
    return false;
  }

  bool _isLibrarian() =>
      _adminService?.currentUser.value.adminType == AdminType.librarian;

  @override
  void initState() {
    super.initState();
    try {
      _userService = Get.find<SingleUserService>();
    } catch (e) {}
    try {
      _adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  Widget _buildComment(BuildContext context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: 1.5),
                  image: comment.imageUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(comment.imageUrl!),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: comment.imageUrl != null
                    ? SizedBox()
                    : Center(child: Icon(Icons.person)),
              ),
              SizedBox(height: 3),
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: comment.rating,
                size: 8.0,
                color: Theme.of(context).colorScheme.primary,
                borderColor: Theme.of(context).colorScheme.secondary,
                spacing: 0.0,
              ),
            ],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 36.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        comment.isAdmin
                            ? Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      comment.commentBy,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            height: 1.2,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  comment.commentBy,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        height: 1.2,
                                      ),
                                ),
                              ),
                        if (_isMineComment(comment))
                          GestureDetector(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                                size: 20,
                              ),
                            ),
                            onTap: () async => await _api.remove(comment),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(minHeight: 48.0),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    comment.content,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          height: 1.2,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: CustomScrollView(
          slivers: [
            HookBuilder(builder: (context) {
              final _rating = useState(5.0);

              return SliverList(
                  delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Center(
                            child: SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) => _rating.value = v,
                              starCount: 5,
                              rating: _rating.value,
                              size: 40.0,
                              color: Theme.of(context).colorScheme.primary,
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                              spacing: 0.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _commentController,
                          maxLines: 5,
                          maxLength: 1000,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Bình luận',
                          ),
                        ),
                        SizedBox(height: Insets.sm),
                        ElevatedButton(
                          onPressed: () {
                            String commentBy = '';
                            String senderId = '';
                            if (_userService != null) {
                              commentBy =
                                  '${_userService!.user.name} (${_userService!.user.className})';
                              senderId = _userService!.user.id;
                            } else if (_adminService != null) {
                              final adminType =
                                  _adminService!.currentUser.value.adminType;
                              senderId = _adminService!.currentUser.value.uid;
                              switch (adminType) {
                                case AdminType.librarian:
                                  commentBy = 'Thư viện Hàn Thuyên';
                                  break;
                                case AdminType.mornitor:
                                  commentBy =
                                      'Quản lí lớp ${_adminService!.currentUser.value.className}';
                                  break;
                                default:
                              }
                            }
                            _api.add(
                              Comment(
                                content: _commentController.text,
                                rating: _rating.value,
                                bookId: widget.book.id!,
                                createdAt: Timestamp.now(),
                                id: Uuid().v4(),
                                senderId: senderId,
                                commentBy: commentBy,
                                isAdmin: _adminService != null,
                                imageUrl: _userService?.user.imageUrl ??
                                    _adminService?.currentUser.value.imageUrl,
                              ),
                            );
                            _commentController.text = '';
                          },
                          child: Center(
                            child: Text('Bình luận'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ));
            }),
            StreamBuilder<List<Comment>>(
              initialData: [],
              stream: _api.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: Text('Không có bình luận nào'),
                      ),
                    ),
                  );
                }

                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildComment(context, snapshot.data![index]),
                  childCount: snapshot.data!.length,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
