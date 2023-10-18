import 'package:benaiah_mobile_app/core/common/widgets/optional_expanded.dart';
import 'package:benaiah_mobile_app/core/extensions/context_extensions.dart';
import 'package:benaiah_mobile_app/core/services/injection_container.dart';
import 'package:benaiah_mobile_app/src/admin/views/admin_home_section.dart';
import 'package:benaiah_mobile_app/src/home/controller/home_controller.dart';
import 'package:benaiah_mobile_app/src/home/models/local_user.dart';
import 'package:benaiah_mobile_app/src/home/widgets/motivation_tile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// /
  static const path = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<LocalUser> motivationFuture;
  final adminNotifier = ValueNotifier(false);

  @override
  void initState() {
    motivationFuture = sl<HomeController>().fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Admin Mode', style: context.theme.textTheme.titleSmall),
            ValueListenableBuilder(
              valueListenable: adminNotifier,
              builder: (_, value, __) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) => adminNotifier.value = value,
                );
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                context.go('/profile');
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/icons/user.png'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: CarouselSlider(
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/$i.jpeg'),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 400,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: adminNotifier,
              builder: (_, value, __) => OptionalExpanded(
                expand: value,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: value
                      ? const AdminHomeSection()
                      : FutureBuilder<LocalUser>(
                          future: motivationFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done ||
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              if (snapshot.data != null) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        context.mediaQuery.viewInsets.bottom +
                                            20,
                                  ),
                                  child: MotivationTile(user: snapshot.data!),
                                );
                              }
                              return Text(
                                'User Not Found',
                                style: context.theme.textTheme.titleLarge,
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
