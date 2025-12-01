import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_String.dart';


import 'package:sumfiun/Sumifun/presentation/pages/ResponsiveAppBar.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';

class RechargeScreen1 extends StatefulWidget {
  const RechargeScreen1({super.key});

  @override
  State<RechargeScreen1> createState() => _RechargeScreen1State();
}

class _RechargeScreen1State extends State<RechargeScreen1>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _message = "";

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // محاكاة تحميل أولي
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int index = 2;

  @override
  Widget build(BuildContext context) {
    // 🧩 نصوص مترجمة
    final titleText = AppStrings.t<String>(context, 'verify_title');
    final introText = AppStrings.t<String>(context, 'verify_intro');
    final labelText = AppStrings.t<String>(context, 'verify_label');
    final hintText = AppStrings.t<String>(context, 'verify_hint');
    final buttonText = AppStrings.t<String>(context, 'verify_button');

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // بطاقة التحقق
                  Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // ✅ شعار كأصل محلي (كان Network)
                          Image.asset(
                            AppImage.Icon_Image,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),

                          // عنوان/وصف
                          Text(
                            "$titleText\n\n$introText",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),

                          // حقل الإدخال
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: labelText,
                                hintText: hintText,
                                prefixIcon: const Icon(Icons.verified,
                                    color: Colors.amber),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: validateCard,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // زر التحقق
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _checkAndUseCard(_controller.text.trim());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: AppColor.primary,
                            ),
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // رسالة الحالة
                          Text(
                            _message,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _message.startsWith("✅")
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  // ✅ رسائل التحقق مترجمة
  String? validateCard(String? value) {
    final msgEmpty = AppStrings.t<String>(context, 'msg_enter_number');
    final msgLen = AppStrings.t<String>(context, 'msg_must_12');
    if (value == null || value.isEmpty) return msgEmpty;
    if (value.length != 12) return msgLen;
    return null;
  }

  Future<void> _checkAndUseCard(String number) async {
    final dbErrorMsg = AppStrings.t<String>(context, 'db_error_message');
    final dbErrorTitle = AppStrings.t<String>(context, 'db_error_title');

    final usedMsg = AppStrings.t<String>(context, 'code_used');
    final notFoundMsg = AppStrings.t<String>(context, 'code_not_found');
    final warnTitle = AppStrings.t<String>(context, 'warn_title');

    final searchErrMsg = AppStrings.t<String>(context, 'search_error');
    final oopsTitle = AppStrings.t<String>(context, 'oops_title');

    try {
      // التحقق من حالة تشغيل الخدمة
      final configDoc = await FirebaseFirestore.instance
          .collection('idclose')
          .doc('7')
          .get();

      if (configDoc.exists && configDoc.data() != null) {
        final bool isOpen = configDoc.data()?['v'] ?? false;

        if (!isOpen) {
          setState(() {
            _message = "❌ $dbErrorMsg";
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: dbErrorTitle,
            desc: "❌ $dbErrorMsg",
            btnOkOnPress: () {},
          ).show();
          return;
        }
      }

      // --- إذا v = true يكمل هنا ---
      final doc = await FirebaseFirestore.instance
          .collection('ids')
          .doc(number)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data();
        final usageDate = DateTime.now();

        // عرض رسالة النجاح
        showSuccessMessage(context, usageDate);

        await FirebaseFirestore.instance
            .collection('ids_used_codes')
            .doc(number)
            .set({
          'id': data?['id'] ?? 'unknown',
          'timestamp': data?['timestamp'] ?? 'unknown',
          'usage_date': usageDate.toIso8601String(),
        });

        await FirebaseFirestore.instance.collection('ids').doc(number).delete();
      } else {
        final usedDoc = await FirebaseFirestore.instance
            .collection('ids_used_codes')
            .doc(number)
            .get();

        final msg = usedDoc.exists ? usedMsg : notFoundMsg;

        setState(() => _message = "❌ $msg");

        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: warnTitle,
          desc: "❌ $msg",
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      setState(() => _message = "❌ $searchErrMsg");

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: oopsTitle,
        desc: "❌ $searchErrMsg",
        btnOkOnPress: () {},
      ).show();
    }
  }

  void showSuccessMessage(BuildContext context, DateTime usageDate) {
    final successTitle = AppStrings.t<String>(context, 'success_title');
    final successIntro = AppStrings.t<String>(context, 'success_intro');
    final entryLabel = AppStrings.t<String>(context, 'entry_date');
    final usageLabel = AppStrings.t<String>(context, 'usage_date');
    final thanks1 = AppStrings.t<String>(context, 'thanks_line1');
    final thanks2 = AppStrings.t<String>(context, 'thanks_line2');
    final thanks3 = AppStrings.t<String>(context, 'thanks_line3');

    final ts = DateFormat('yyyy-MM-dd – HH:mm').format(usageDate);

    final msg = "✅ $successIntro\n"
        "$entryLabel: $ts\n"
        "$usageLabel: $ts\n\n"
        "$thanks1\n$thanks2\n$thanks3";

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: successTitle,
      desc: msg,
      btnOkOnPress: () {},
    ).show();
  }
}
