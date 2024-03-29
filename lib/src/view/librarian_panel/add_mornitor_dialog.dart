import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/image_whisperer.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/controllers/librarian_controller.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddMonitorDialog extends HookWidget {
  const AddMonitorDialog({Key? key, required this.grade, required this.classNumber}) : super(key: key);

  final int grade;
  final int classNumber;

  double get imageHeight => 230.0;
  double get dataHeight => 4 * (56.0 + Insets.m);
  double dialogHeight(BuildContext context) => PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.height : 6 * (59.0 + Insets.m);
  double dialogWidth(BuildContext context) => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile
          : MediaQuery.of(context).size.width;
  double textFieldWidth(BuildContext context) => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0 - 234.0 - 2 * Insets.m
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile - 234.0 - 2 * Insets.m
          : MediaQuery.of(context).size.width;

  Widget _buildActionButton(
    BuildContext context, {
    EdgeInsets? padding,
    required LibrarianController controller,
    required ValueNotifier<ImageFile?> imageFile,
    required String name,
    required String email,
    required String phone,
    required String password,
    required int memberNumber,
  }) =>
      Padding(
        padding: padding ?? EdgeInsets.only(bottom: Insets.m, right: Insets.m),
        child: SizedBox(
          height: 53.0,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Hủy".toUpperCase(),
                  ).bigMode,
                ),
              ),
              HSpace(Insets.sm),
              Expanded(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      AdminUser user = AdminUser(
                        email: email,
                        name: name,
                        phone: phone,
                        adminType: AdminType.mornitor,
                        uid: Uuid().v4(),
                        memberNumber: 50,
                        className: '${grade}A${classNumber}',
                      );

                      if (imageFile.value != null) {
                        String imageUrl = await controller.api.admin.uploadMornitorImage(imageFile.value!, user);
                        user = user.copyWith(imageUrl: imageUrl);

                        bool success = await controller.addMornitor(
                          user,
                          grade: grade,
                          classNumber: classNumber,
                        );

                        if (success) {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Thêm".toUpperCase(),
                    ).bigMode,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final image = useState<ImageProvider?>(null);
    final _imageFile = useState<ImageFile?>(null);
    final _hover = useState<bool>(false);
    final _disableColor = useState<Color?>(null);
    final _showImageError = useState<bool>(false);

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final memberNumberController = useTextEditingController();

    final controller = useProvider(librarianControllerProvider.notifier);

    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 3.0,
        child: Container(
          height: dialogHeight(context),
          constraints: BoxConstraints(
            maxHeight: dialogHeight(context),
            maxWidth: dialogWidth(context),
          ),
          color: Colors.white,
          child: Scaffold(
            appBar: AppBar(title: Text("Thêm lớp trưởng ${grade}A${classNumber}")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (PageBreak.defaultPB.isMobile(context)) ...[
                      imageField(context, image, _hover, _imageFile, _disableColor, _showImageError),
                      mornitorFormField(
                        context,
                        nameController: nameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        passwordController: passwordController,
                        memberNumberController: memberNumberController,
                        formKey: _formKey,
                      ),
                    ],
                    if (!PageBreak.defaultPB.isMobile(context))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageField(context, image, _hover, _imageFile, _disableColor, _showImageError).expanded(),
                          mornitorFormField(
                            context,
                            nameController: nameController,
                            emailController: emailController,
                            phoneController: phoneController,
                            passwordController: passwordController,
                            memberNumberController: memberNumberController,
                            formKey: _formKey,
                          ),
                        ],
                      ),
                  ],
                ),
                _buildActionButton(
                  context,
                  controller: controller,
                  padding: EdgeInsets.only(top: Insets.m, bottom: Insets.m, right: Insets.m),
                  imageFile: _imageFile,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                  memberNumber: int.parse(memberNumberController.text),
                ),
              ],
            ).padding(
              top: Insets.m,
              left: Insets.m,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox mornitorFormField(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController memberNumberController,
    required TextEditingController passwordController,
    required GlobalKey<FormState> formKey,
  }) {
    return SizedBox(
      height: dataHeight,
      width: textFieldWidth(context),
      child: Padding(
        padding: EdgeInsets.only(right: Insets.m),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Họ và tên'),
              ),
              VSpace(Insets.m),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
              ),
              VSpace(Insets.m),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Số thành viên'),
              ),
              VSpace(Insets.m),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Địa chỉ email'),
              ),
              VSpace(Insets.m),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageField(
    BuildContext context,
    ValueNotifier<ImageProvider<Object>?> image,
    ValueNotifier<bool> _hover,
    ValueNotifier<ImageFile?> _imageFile,
    ValueNotifier<Color?> _disableColor,
    ValueNotifier<bool> _showImageError,
  ) {
    if (_imageFile.value == null || image.value == null) {
      return MouseRegion(
        onEnter: (_) {
          _disableColor.value = Theme.of(context).primaryColor.withOpacity(0.5);
        },
        onExit: (_) {
          _disableColor.value = Theme.of(context).disabledColor.withOpacity(0.5);
        },
        child: DottedBorder(
          radius: Corners.s10Radius,
          borderType: BorderType.RRect,
          dashPattern: [Insets.sm],
          color: _disableColor.value ?? Theme.of(context).disabledColor,
          child: Container(
            width: PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.width : imageHeight,
            height: dataHeight - 4.0,
            child: Stack(
              children: [
                Container(
                  width: PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.width : imageHeight,
                  height: dataHeight - 4.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...((GetPlatform.isMobile)
                          ? [
                              IconButton(
                                icon: Icon(Entypo.camera),
                                iconSize: 40.0,
                                color: _disableColor.value ?? Theme.of(context).disabledColor,
                                onPressed: () => imagePicker(ImageSource.camera, _imageFile, image),
                              ),
                              IconButton(
                                icon: Icon(Entypo.image),
                                iconSize: 40.0,
                                color: _disableColor.value ?? Theme.of(context).disabledColor,
                                onPressed: () => imagePicker(ImageSource.gallery, _imageFile, image),
                              ),
                            ]
                          : [
                              IconButton(
                                icon: Icon(Entypo.image),
                                iconSize: 80.0,
                                color: _disableColor.value ?? Theme.of(context).disabledColor,
                                onPressed: () => imagePicker(ImageSource.gallery, _imageFile, image),
                              ),
                            ]),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Durations.fast,
                    curve: Curves.decelerate,
                    height: _showImageError.value ? 48.0 : 0.0,
                    width: imageHeight - Insets.m,
                    margin: EdgeInsets.only(bottom: Insets.sm),
                    decoration: BoxDecoration(
                      borderRadius: Corners.s5Border,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Không được bỏ trống",
                      style: Theme.of(context).snackBarTheme.contentTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).paddingOnly(right: Insets.m, bottom: PageBreak.defaultPB.isMobile(context) ? Insets.m : 0.0),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        right: Insets.m,
        bottom: PageBreak.defaultPB.isMobile(context) ? Insets.m : 0.0,
      ),
      child: SizedBox(
        width: PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.width : imageHeight,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                borderRadius: Corners.s5Border,
              ),
              height: dataHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Corners.s5),
                child: Image(
                  image: image.value!,
                  width: PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.width : imageHeight,
                  height: dataHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: MouseRegion(
                  onEnter: (_) => _hover.value = !_hover.value,
                  onExit: (_) => _hover.value = !_hover.value,
                  child: GestureDetector(
                    onTap: () => _imageFile.value = null,
                    child: Container(
                      margin: EdgeInsets.all(Insets.sm),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(_hover.value ? 1.0 : 0.4),
                        borderRadius: Corners.s5Border,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void imagePicker(ImageSource source, ValueNotifier<ImageFile?> _imageFile, ValueNotifier<ImageProvider<Object>?> _image) async {
    _imageFile.value = await FileUtils.image(source);
    if (kIsWeb) {
      var blobImg = BlobImage(_imageFile.value!.webImage, name: _imageFile.value!.webImage!.name);
      _image.value = CachedNetworkImageProvider(blobImg.url!);
    } else {
      var memory = await _imageFile.value!.image!.readAsBytes();
      _image.value = MemoryImage(memory);
    }
  }
}
