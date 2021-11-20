import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:webviewx/webviewx.dart';

class BookPreviewBottomSheet extends StatefulWidget {
  const BookPreviewBottomSheet({Key? key, required this.book})
      : super(key: key);
  final Book book;

  @override
  State<BookPreviewBottomSheet> createState() => _BookPreviewBottomSheetState();
}

class _BookPreviewBottomSheetState extends State<BookPreviewBottomSheet> {
  AdminService? adminService;
  bool _isLibrarian() =>
      adminService != null &&
      adminService!.currentUser.value.adminType == AdminType.librarian;

  BookService? bookService;

  late Book book;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
    try {
      bookService = Get.find<BookService>();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
        actions: _isLibrarian()
            ? [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: 180,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(16),
                              child: HookBuilder(builder: (context) {
                                final pdfUrlController =
                                    useTextEditingController(
                                        text: widget.book.pdfUrl);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sửa bản xem trước',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    VSpace(16),
                                    TextField(controller: pdfUrlController),
                                    VSpace(8),
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          child: Text('Hủy'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        HSpace(8),
                                        ElevatedButton(
                                          child: Text('Sửa'),
                                          onPressed: () {
                                            if (bookService != null) {
                                              bookService!
                                                  .edit(
                                                widget.book.copyWith(
                                                    pdfUrl:
                                                        pdfUrlController.text),
                                              )
                                                  .then((_) {
                                                setState(() {
                                                  book = book.copyWith(
                                                    pdfUrl:
                                                        pdfUrlController.text,
                                                  );
                                                });
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    );
                    bookService?.edit(widget.book);
                  },
                ),
              ]
            : [],
      ),
      body: book.pdfUrl == null
          ? Center(child: Text('Không có bản xem trước'))
          : WebViewX(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              initialContent: book.pdfUrl!,
            ),
    );
  }
}
