import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/main_screen/book_list_view/book_list_view_cubit.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';

class BookListView extends StatelessWidget {
  final List<Book> bookList;
  const BookListView({Key key, this.bookList}) : super(key: key);

  double get widgetHeight => Get.height / 2 - 50.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightForFinite(
        height: widgetHeight,
      ),
      child: BlocBuilder<BookListViewCubit, BookListViewState>(
        cubit: context.watch<BookListViewCubit>(),
        builder: (context, state) {
          Book currentBook = state.when(
            closeBook: () => null,
            openBook: (book) => book,
          );
          return ListView.builder(
            itemCount: bookList.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Book _indexedBook = bookList[index];
              return GestureDetector(
                onTap: () {
                  if (currentBook == bookList[index]) {
                    context.read<BookListViewCubit>().closeBook();
                  } else {
                    context.read<BookListViewCubit>().openBook(_indexedBook);
                  }
                },
                child: Container(
                  height: widgetHeight,
                  width: 226,
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        height: widgetHeight * 3 / 4,
                        width: 226,
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(
                            _indexedBook == currentBook ? 10.0 - 3.0 : 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _indexedBook == currentBook
                                ? HTlibColorTheme.green
                                : Colors.transparent,
                            width: _indexedBook == currentBook ? 3.0 : 0.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            _indexedBook.coverImg,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_indexedBook.title}",
                              overflow: TextOverflow.ellipsis,
                              style: HTlibTextStyle.headline6Text,
                            ),
                            Text(
                              "${_indexedBook.author}",
                              overflow: TextOverflow.ellipsis,
                              style: HTlibTextStyle.normalText.copyWith(
                                color: HTlibColorTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
