import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/main_screen/search_bar/search_bar_cubit.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          Flexible(child: Container()),
          Flexible(
            child: BlocConsumer<SearchBarCubit, SearchBarState>(
              cubit: context.watch<SearchBarCubit>(),
              listener: (context, state) {
                if (state == SearchBarState.focusText()) {
                  FocusScope.of(context).unfocus();
                }
              },
              builder: (BuildContext context, state) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: HTlibColorTheme.grey.withOpacity(0.5),
                      width: context.select<SearchBarCubit, bool>(
                        (SearchBarCubit cb) => cb.focusState,
                      )
                          ? 2.5
                          : 1,
                    ),
                  ),
                  padding: EdgeInsets.only(right: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search,
                            color: HTlibColorTheme.iconColor),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          controller: context
                              .select<SearchBarCubit, TextEditingController>(
                            (SearchBarCubit cb) => cb.searchTextController,
                          ),
                          cursorWidth: 1,
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration.collapsed(
                            fillColor: Colors.amber,
                            hintText: "Tìm kiếm sách, vd: homo sapiens,...",
                          ),
                          onTap: () =>
                              context.read<SearchBarCubit>().focusText(context),
                          scrollPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
