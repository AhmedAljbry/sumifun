import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';


// حوار التنبيه (مستخدم عندك)
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class VerificationCard extends StatefulWidget {
  const VerificationCard({super.key});

  @override
  State<VerificationCard> createState() => _VerificationCardState();
}

class _VerificationCardState extends State<VerificationCard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _message = "";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
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

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    // 🧩 نصوص مترجمة
    final intro = AppStrings.ts(context, 'verify_intro');
    final label = AppStrings.ts(context, 'verify_label');
    final hint = AppStrings.ts(context, 'verify_hint');
    final verifyBtn = AppStrings.ts(context, 'verify_button');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isLargeScreen
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Image.asset(
                        AppImage.Icon_Image,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: _FormBody(
                      formKey: _formKey,
                      controller: _controller,
                      intro: intro,
                      label: label,
                      hint: hint,
                      verifyBtn: verifyBtn,
                      onVerify: _onVerify,
                      message: _message,
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  Image.asset(
                    AppImage.Icon_Image,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  _FormBody(
                    formKey: _formKey,
                    controller: _controller,
                    intro: intro,
                    label: label,
                    hint: hint,
                    verifyBtn: verifyBtn,
                    onVerify: _onVerify,
                    message: _message,
                    centerIntro: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String? validateCard(String? value) {
    final msgEnter = AppStrings.ts(context, 'msg_enter_number');
    final msg12    = AppStrings.ts(context, 'msg_must_12');

    final v = value?.trim() ?? '';
    if (v.isEmpty) return msgEnter;
    if (v.length != 12) return msg12;
    return null;
  }

  Future<void> _onVerify() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _checkAndUseCard(_controller.text.trim());
  }

  Future<void> _checkAndUseCard(String number) async {
    try {
      // التحقق من حالة تشغيل الخدمة
      final configDoc = await FirebaseFirestore.instance
          .collection('idclose')
          .doc('7')
          .get();

      if (configDoc.exists && configDoc.data() != null) {
        final bool isOpen = configDoc.data()?['v'] ?? false;
        if (!isOpen) {
          final dbErrTitle = AppStrings.ts(context, 'db_error_title');
          final dbErrMsg   = AppStrings.ts(context, 'db_error_message');

          setState(() => _message = "❌ $dbErrMsg");
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: dbErrTitle,
            desc: "❌ $dbErrMsg",
            btnOkOnPress: () {},
          ).show();
          return;
        }
      }

      // البحث عن الكود
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

        // حذف الكود من القائمة النشطة
        await FirebaseFirestore.instance.collection('ids').doc(number).delete();

        setState(() => _message = "✅ ${AppStrings.ts(context, 'success_intro')}");
      } else {
        final usedDoc = await FirebaseFirestore.instance
            .collection('ids_used_codes')
            .doc(number)
            .get();

        final warnTitle = AppStrings.ts(context, 'warn_title');
        final codeUsed  = AppStrings.ts(context, 'code_used');
        final notFound  = AppStrings.ts(context, 'code_not_found');

        final msg = usedDoc.exists ? codeUsed : notFound;

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
      final oopsTitle = AppStrings.ts(context, 'oops_title');
      final searchErr = AppStrings.ts(context, 'search_error');

      setState(() => _message = "❌ $searchErr");

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: oopsTitle,
        desc: "❌ $searchErr",
        btnOkOnPress: () {},
      ).show();
    }
  }

  void showSuccessMessage(BuildContext context, DateTime usageDate) {
    final successTitle = AppStrings.ts(context, 'success_title');
    final successIntro = AppStrings.ts(context, 'success_intro');
    final entryDateKey = AppStrings.ts(context, 'entry_date');
    final usageDateKey = AppStrings.ts(context, 'usage_date');
    final thanks1      = AppStrings.ts(context, 'thanks_line1');
    final thanks2      = AppStrings.ts(context, 'thanks_line2');
    final thanks3      = AppStrings.ts(context, 'thanks_line3');

    // ينسجم مع اللغة الحالية
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final df = DateFormat('yyyy-MM-dd – HH:mm', localeName);

    final msg = "✅ $successIntro\n"
        "$entryDateKey: ${df.format(usageDate)}\n"
        "$usageDateKey: ${df.format(usageDate)}\n\n"
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

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.formKey,
    required this.controller,
    required this.intro,
    required this.label,
    required this.hint,
    required this.verifyBtn,
    required this.onVerify,
    required this.message,
    this.centerIntro = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String intro;
  final String label;
  final String hint;
  final String verifyBtn;
  final VoidCallback onVerify;
  final String message;
  final bool centerIntro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      centerIntro ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          intro,
          textAlign: centerIntro ? TextAlign.center : TextAlign.start,
          style: AppStyles.styleRegular14(context).copyWith(
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),

        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: const Icon(Icons.verified, color: Colors.amber),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (v) {
              // نستدعي تحقق خارجي للحفاظ على الترجمة
              final state = context.findAncestorStateOfType<_VerificationCardState>();
              return state?.validateCard(v);
            },
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: onVerify,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            backgroundColor: AppColor.primary,
          ),
          child: Text(verifyBtn, style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(height: 16),

        if (message.isNotEmpty)
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: message.startsWith("✅") ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
