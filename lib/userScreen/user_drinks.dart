import 'package:flutter/material.dart';
import '../add_button/drink_detail_page.dart';
import '../localJsonBackend_lijun/drink_request_manager.dart';
import '../mixy_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {super.key, this.mainScreenAnimationController, this.mainScreenAnimation});

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/mixyLogo.png',
  ];
  List<Drink> drinks = []; // This will hold your drinks
  final dataManager = DataManager();
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    fetchDrinks();
  }

  Future<void> fetchDrinks() async {
    drinks = await dataManager
        .getDrinks(); // Assume getDrinks() is accessible or imported
    print(drinks);
    setState(() {}); // Update the state to reflect new drinks
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                  children: List<Widget>.generate(
                    drinks.length, // Use the length of drinks
                    (int index) {
                      final int count = drinks.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController?.forward();
                      return AreaView(
                        name: drinks[index].name, // Pass the drink name
                        favorite:
                            drinks[index].favorite, // Pass favorite status
                        animation: animation,
                        animationController: animationController!,
                        drink: drinks[index], // Pass the drink object
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    super.key,
    required this.animationController,
    required this.animation,
    required this.name,
    required this.favorite,
    required this.drink,
  });

  final AnimationController? animationController;
  final Animation<double>? animation;
  final String name;
  final bool favorite;
  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: MixyAppTheme.white,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: MixyAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DrinkDetailScreen(drink: drink),
                    ));
                  },
                  child: Stack(
                    children: <Widget>[
                      // Assuming you use an image or placeholder here
                      Positioned.fill(
                        child: Image.asset('assets/mixy_app/mixyLogo.png',
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(150, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
