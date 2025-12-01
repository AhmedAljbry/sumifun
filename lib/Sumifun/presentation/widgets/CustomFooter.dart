import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Home.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/AuthorizedDistributorsPage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/CustomerServicePage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/PrivacyPolicyPage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/ReturnPolicyPage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/TermsConditionsPage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/about_us.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  // ✅ دالة مساعدة للملاحة بدون أي تغيير في التصميم
  void _goTo(BuildContext context, Widget page, {bool replaceAll = false}) {
    final route = MaterialPageRoute(builder: (_) => page);
    if (replaceAll) {
      Navigator.of(context).pushAndRemoveUntil(route, (r) => false);
    } else {
      Navigator.of(context).push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      Widget content;
      if (width >= 1000) {
        content = _buildDesktopFooter(context);
      } else if (width >= 600) {
        content = _buildTabletFooter(context);
      } else {
        content = _buildMobileFooter(context);
      }

      return Container(
        padding: const EdgeInsets.all(20),
        color: Colors.blue[900],
        child: content,
      );
    });
  }

  // ✅ Mobile Footer
  Widget _buildMobileFooter(BuildContext context) {
    final mainLinksTitle = AppStrings.ts(context, 'footer_main_links_title');
    final legalLinksTitle = AppStrings.ts(context, 'footer_legal_links_title');
    final supportTitle = AppStrings.ts(context, 'footer_support_title');
    final devsTitle = AppStrings.ts(context, 'footer_developers_title');
    final followTitle = AppStrings.ts(context, 'footer_follow_us_title');
    final copyright = AppStrings.ts(context, 'footer_copyright');

    final mainLinks = <String>[
      AppStrings.ts(context, 'footer_link_home'),
      AppStrings.ts(context, 'footer_link_about'),
      AppStrings.ts(context, 'footer_link_distributors'),
      AppStrings.ts(context, 'footer_link_support'),
    ];

    final legalLinks = <String>[
      AppStrings.ts(context, 'footer_link_return'),
      AppStrings.ts(context, 'footer_link_privacy'),
      AppStrings.ts(context, 'footer_link_terms'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFooterColumn(
          mainLinksTitle,
          mainLinks,
          const [Home(), AboutUsPage(), AuthorizedDistributorsPage(), CustomerServicePage()],
          context,
        ),
        const SizedBox(height: 20),
        _buildFooterColumn(
          legalLinksTitle,
          legalLinks,
          const [ReturnPolicyPage(), PrivacyPolicyPage(), TermsConditionsPage()],
          context,
        ),
        const SizedBox(height: 20),

        _buildSectionTitle(supportTitle),
        Row(
          children: [
            _buildIconText(
              FontAwesomeIcons.whatsapp,
              AppStrings.ts(context, 'footer_contact_whatsapp'),
            ),
            const SizedBox(width: 20),
            _buildIconText(
              Icons.email,
              AppStrings.ts(context, 'footer_contact_email'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildSectionTitle(devsTitle),
        InkWell(
          onTap: () {},
          child: _buildIconText(
            FontAwesomeIcons.code,
            AppStrings.ts(context, 'footer_developers_link'),
          ),
        ),
        const SizedBox(height: 20),

        _buildSectionTitle(followTitle),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          children: [
            _buildSocialIcon(
              FontAwesomeIcons.facebook,
              AppStrings.ts(context, 'footer_social_facebook'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.snapchat,
              AppStrings.ts(context, 'footer_social_snapchat'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.instagram,
              AppStrings.ts(context, 'footer_social_instagram'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.youtube,
              AppStrings.ts(context, 'footer_social_youtube'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.tiktok,
              AppStrings.ts(context, 'footer_social_tiktok'),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 30),
        Center(
          child: Text(
            copyright,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ✅ Tablet Footer
  Widget _buildTabletFooter(BuildContext context) {
    final mainLinksTitle = AppStrings.ts(context, 'footer_main_links_title');
    final legalLinksTitle = AppStrings.ts(context, 'footer_legal_links_title');
    final supportTitle = AppStrings.ts(context, 'footer_support_title');
    final devsTitle = AppStrings.ts(context, 'footer_developers_title');
    final followTitle = AppStrings.ts(context, 'footer_follow_us_title');
    final copyright = AppStrings.ts(context, 'footer_copyright');

    final mainLinks = <String>[
      AppStrings.ts(context, 'footer_link_home'),
      AppStrings.ts(context, 'footer_link_about'),
      AppStrings.ts(context, 'footer_link_distributors'),
      AppStrings.ts(context, 'footer_link_support'),
    ];

    final legalLinks = <String>[
      AppStrings.ts(context, 'footer_link_return'),
      AppStrings.ts(context, 'footer_link_privacy'),
      AppStrings.ts(context, 'footer_link_terms'),
    ];

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 20,
          children: [
            _buildFooterColumn(
              mainLinksTitle,
              mainLinks,
              const [Home(), AboutUsPage(), AuthorizedDistributorsPage(), CustomerServicePage()],
              context,
            ),
            const SizedBox(height: 20),
            _buildFooterColumn(
              legalLinksTitle,
              legalLinks,
              const [ReturnPolicyPage(), PrivacyPolicyPage(), TermsConditionsPage()],
              context,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(supportTitle),
                _buildIconText(
                  FontAwesomeIcons.whatsapp,
                  AppStrings.ts(context, 'footer_contact_whatsapp'),
                ),
                const SizedBox(height: 10),
                _buildIconText(
                  Icons.email,
                  AppStrings.ts(context, 'footer_contact_email'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(devsTitle),
                InkWell(
                  onTap: () {},
                  child: _buildIconText(
                    FontAwesomeIcons.code,
                    AppStrings.ts(context, 'footer_developers_link'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionTitle(followTitle),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            _buildSocialIcon(
              FontAwesomeIcons.facebook,
              AppStrings.ts(context, 'footer_social_facebook'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.snapchat,
              AppStrings.ts(context, 'footer_social_snapchat'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.instagram,
              AppStrings.ts(context, 'footer_social_instagram'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.youtube,
              AppStrings.ts(context, 'footer_social_youtube'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.tiktok,
              AppStrings.ts(context, 'footer_social_tiktok'),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 30),
        Center(
          child: Text(
            copyright,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ✅ Desktop Footer
  Widget _buildDesktopFooter(BuildContext context) {
    final mainLinksTitle = AppStrings.ts(context, 'footer_main_links_title');
    final legalLinksTitle = AppStrings.ts(context, 'footer_legal_links_title');
    final supportTitle = AppStrings.ts(context, 'footer_support_title');
    final devsTitle = AppStrings.ts(context, 'footer_developers_title');
    final followTitle = AppStrings.ts(context, 'footer_follow_us_title');
    final copyright = AppStrings.ts(context, 'footer_copyright');

    final mainLinks = <String>[
      AppStrings.ts(context, 'footer_link_home'),
      AppStrings.ts(context, 'footer_link_about'),
      AppStrings.ts(context, 'footer_link_distributors'),
      AppStrings.ts(context, 'footer_link_support'),
    ];

    final legalLinks = <String>[
      AppStrings.ts(context, 'footer_link_return'),
      AppStrings.ts(context, 'footer_link_privacy'),
      AppStrings.ts(context, 'footer_link_terms'),
    ];

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFooterColumn(
              mainLinksTitle,
              mainLinks,
              const [Home(), AboutUsPage(), AuthorizedDistributorsPage(), CustomerServicePage()],
              context,
            ),
            _buildFooterColumn(
              legalLinksTitle,
              legalLinks,
              const [ReturnPolicyPage(), PrivacyPolicyPage(), TermsConditionsPage()],
              context,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(supportTitle),
                _buildIconText(
                  FontAwesomeIcons.whatsapp,
                  AppStrings.ts(context, 'footer_contact_whatsapp'),
                ),
                const SizedBox(height: 10),
                _buildIconText(
                  Icons.email,
                  AppStrings.ts(context, 'footer_contact_email'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(devsTitle),
                InkWell(
                  onTap: () {},
                  child: _buildIconText(
                    FontAwesomeIcons.code,
                    AppStrings.ts(context, 'footer_developers_link'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionTitle(followTitle),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              FontAwesomeIcons.facebook,
              AppStrings.ts(context, 'footer_social_facebook'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.snapchat,
              AppStrings.ts(context, 'footer_social_snapchat'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.instagram,
              AppStrings.ts(context, 'footer_social_instagram'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.youtube,
              AppStrings.ts(context, 'footer_social_youtube'),
            ),
            _buildSocialIcon(
              FontAwesomeIcons.tiktok,
              AppStrings.ts(context, 'footer_social_tiktok'),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 30),
        Center(
          child: Text(
            copyright,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterColumn(
      String title,
      List<String> links,
      List<Widget> pages,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        _buildLinkColumn(links, pages, context),
      ],
    );
  }

  // ✅ تفعيل الملاحة هنا بدون أي تغيير بصري
  Widget _buildLinkColumn(
      List<String> links,
      List<Widget> pages,
      BuildContext context,
      ) {
    assert(links.length == pages.length, 'links and pages must have the same length');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(links.length, (index) {
        return TextButton(
          onPressed: () {
            final page = pages[index];
            if (page is Home) {
              _goTo(context, const Home(), replaceAll: true);
            } else {
              _goTo(context, page);
            }
          },
          child: Text(
            links[index],
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 24),
      tooltip: tooltip,
      onPressed: () {},
    );
  }
}
