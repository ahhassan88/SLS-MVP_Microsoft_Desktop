import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sls_mvp_microsoft/constants.dart';
import 'package:sls_mvp_microsoft/core/utils/assets.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_loading_indicator.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_snack_bar.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/chat_view_body.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/home_view_body.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/settings_view_body.dart';
import 'package:sls_mvp_microsoft/features/home/view_model/signout_cubit/signout_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;
  final List<Widget> _pages = const [
    SettingsViewBody(),
    HomeViewBody(),
    ChatViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
            ),
            child: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<SignoutCubit>(context).signout();
                    },
                    icon: const Icon(Icons.logout))
              ],
              backgroundColor: kBGColor,
              title: const Image(
                height: 150,
                image: AssetImage(AssetsData.logoMini),
              ),
            ),
          ),
        ),
        backgroundColor: kBGColor,
        bottomNavigationBar: curvedBottomNav(),
        body: BlocListener<SignoutCubit, SignoutState>(
          listener: (context, state) {
            if (state is SignoutSuccess) {
              GoRouter.of(context).push('/login');
            } else if (state is SignoutFailure) {
              showSnackBar(context, "signout failure");
            } else if (state is SignoutLoading) {}
          },
          child: SafeArea(
            child:
                _pages[_selectedIndex], // Display current page based on index
          ),
        ));
  }

  CurvedNavigationBar curvedBottomNav() {
    return CurvedNavigationBar(
      index: _selectedIndex, // Set initial selected index
      backgroundColor: kBGColor,
      color: kPrimaryColor,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        Icon(Icons.settings, color: Colors.white),
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.chat, color: Colors.white),
      ],
    );
  }
}
