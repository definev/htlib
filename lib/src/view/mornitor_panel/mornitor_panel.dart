import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/librarian_panel/librarian_bottom_bar.dart';
import 'package:htlib/src/view/librarian_panel/profile_section.dart';
import 'package:htlib/src/view/settings/components/setting_bottom_bar.dart';
import 'package:htlib/src/view/settings/components/setting_section.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';

class MornitorPanel extends HookWidget {
  MornitorPanel({Key? key}) : super(key: key);

  late final AdminService adminService;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      try {
        adminService = Get.find();
      } catch (e) {}
    });

    final profileExpansion = useState(false);
    final mornitorExpansion = useState(false);
    final settingExpansion = useState(false);

    if (PageBreak.defaultPB.isDesktop(context)) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          VSpace(59.0),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      padding: EdgeInsets.only(top: 15.0, left: 15.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Corners.s5),
                        child: adminService.currentUser.value.imageUrl != null
                            ? Image.network(
                                "${adminService.currentUser.value.imageUrl}",
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              )
                            : SvgPicture.string(
                                multiavatar('cvufn230fh2finsaifn[0aesrf1c14-12v nb4p2qnvu49q23[0t8rvhnq30THQ30HR0I')),
                      ),
                    ),
                    _buildAdminUserField(context, title: "Họ và tên", value: adminService.currentUser.value.name),
                    _buildAdminUserField(context, title: "Email", value: adminService.currentUser.value.email),
                    _buildAdminUserField(context, title: "Số điện thoại", value: adminService.currentUser.value.phone),
                    _buildAdminUserField(context,
                        title: "Vai trò",
                        value:
                            adminService.currentUser.value.adminType == AdminType.librarian ? "Thủ thư" : "Lớp trưởng"),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 59.0,
                  width: 0.5,
                  margin: EdgeInsets.only(left: 15.0),
                  color: Theme.of(context).disabledColor,
                ),
                Expanded(
                  child: ListView(
                    children: _buildSection(
                      context,
                      mornitorExpansion: mornitorExpansion,
                      settingExpansion: settingExpansion,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (PageBreak.defaultPB.isTablet(context)) {
      return CustomScrollView(
        slivers: [
          HtlibSliverAppBar(
            bottom: LibrarianBottomBar(),
            title: AppConfig.tabRentingHistory,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              _buildSection(
                context,
                profileExpansion: profileExpansion,
                mornitorExpansion: mornitorExpansion,
                settingExpansion: settingExpansion,
              ),
            ),
          ),
        ],
      );
    }
    return CustomScrollView(
      slivers: [
        HtlibSliverAppBar(
          bottom: SettingBottomBar(),
          title: AppConfig.tabSetting,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            _buildSection(
              context,
              profileExpansion: profileExpansion,
              mornitorExpansion: mornitorExpansion,
              settingExpansion: settingExpansion,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSection(
    BuildContext context, {
    ValueNotifier<bool>? profileExpansion,
    required ValueNotifier<bool> mornitorExpansion,
    required ValueNotifier<bool> settingExpansion,
  }) =>
      [
        if (!PageBreak.defaultPB.isDesktop(context))
          ExpansionTile(
            tilePadding: EdgeInsets.only(
              top: Insets.m,
              bottom: Insets.m,
              left: 0.0,
              right: 15.0,
            ),
            childrenPadding: EdgeInsets.only(bottom: 10),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(
                    Icons.person_pin,
                    color: profileExpansion!.value
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  'Thông tin cá nhân',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: profileExpansion.value
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
            children: [ProfileSection(adminService: adminService)],
            onExpansionChanged: (value) => profileExpansion.value = value,
            initiallyExpanded: profileExpansion.value,
          ),
        ExpansionTile(
          tilePadding: EdgeInsets.only(
            top: Insets.m,
            bottom: Insets.m,
            left: 0.0,
            right: 15.0,
          ),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(
                  Icons.settings,
                  color: settingExpansion.value
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Text(
                'Cài đặt',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: settingExpansion.value
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ],
          ),
          children: [SettingSection(), VSpace(Insets.m)],
          onExpansionChanged: (value) => settingExpansion.value = value,
          initiallyExpanded: settingExpansion.value,
        ),
      ];

  Widget _buildAdminUserField(
    BuildContext context, {
    required String title,
    required String value,
  }) =>
      Column(
        children: [
          SizedBox(height: Insets.l),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: Insets.sm),
          Text(value),
        ],
      );
}
