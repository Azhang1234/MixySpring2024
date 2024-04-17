import 'package:flutter/material.dart';
import 'package:mixyspring2024/gpt_lijun/getRecomd.dart';
import 'package:mixyspring2024/ui_view/add_button_view.dart';
import 'package:mixyspring2024/ui_view/running_view.dart';
import 'package:mixyspring2024/ui_view/title_view.dart';
import 'package:mixyspring2024/ui_view/workout_view.dart';
import 'package:mixyspring2024/localJsonBackend_lijun/drink_request_manager.dart';

import '../mixy_app_theme.dart';

class AddButtonScreen extends StatefulWidget {
  const AddButtonScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _AddButtonScreenState createState() => _AddButtonScreenState();
}

// this is the screen widget that pops up after clicking "Mix it Up!"
class NewScreen extends StatefulWidget {
  final Drink drink;

  NewScreen({required this.drink});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drink.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var ingredient in widget.drink.ingredients)
              Text('- $ingredient'),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.drink.instructions),
            SizedBox(height: 20),
            Text(
              'Equipment:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var equipment in widget.drink.equipments)
              Text('- $equipment'),
          ],
        ),
      ),
    );
  }
}

class _AddButtonScreenState extends State<AddButtonScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Select your Drink Options:',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    
    // this is the grid array of options for the drink
    listViews.add(
      AddButtonView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Generate a Mixy Drink!',
        subTxt: 'more',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // this is the "Mix it Up" button
    // CallGPT() is called when the button is pressed
    // a NewScreen is pushed onto the Navigator stack, which shiould show the drink(s) reccomended
    listViews.add(
    Container(
      width: 220, // increased size to accommodate margin
      height: 220,
      margin: const EdgeInsets.all(20.0), // adds pixels of space around the Container
      child: InkWell(
        onTap: () async {
          print("GPT Called");
          
          // show the loading dialog
          showLoadingDialog(context);

          // simulate some processing delay
          // EDIT THE DELAY HERE
          await Future.delayed(Duration(seconds: 2));

          // dimiss dialog
          Navigator.of(context, rootNavigator: true).pop();
          
          // LETTING GPT DO ITS THING (BUT IT COSTS MONEY SO LEAVE IT COMMENTED OUT FOR NOW)
          final drink = await CallGPT();

          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewScreen(drink: drink)),
        );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/mixy_app/Mix_it_Up.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // prevents the dialog from closing on tap outside
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // loading spinner...
              SizedBox(width: 20),
              Text("Mixing... Please wait!"), // loading text...
              ],
            ),
          ),
        );
      },
    );
  }

  Drink processRawStringToDrink(String rawString) {
    // Define regex patterns to extract information
    final namePattern = RegExp(r"is a (.+?)\. Here's how to make it:");
    final ingredientsPattern = RegExp(r'Ingredients:\s+- (.+?)\n\nInstructions:', dotAll: true);
    final instructionsPattern = RegExp(r'Instructions:\s+(.+?)\n\n', dotAll: true);
    final equipmentPattern = RegExp(r'Equipment:\s+- (.+?)(\n\n|$)', dotAll: true);

    // extracting information using regex
    final nameMatches = namePattern.firstMatch(rawString);
    final ingredientsMatches = ingredientsPattern.firstMatch(rawString);
    final instructionsMatches = instructionsPattern.firstMatch(rawString);
    final equipmentMatches = equipmentPattern.firstMatch(rawString);

    // processing extracted information
    final name = nameMatches?.group(1) ?? "Unknown Drink";
    final ingredientsList = ingredientsMatches?.group(1)?.split('\n- ') ?? [];
    final instructions = instructionsMatches?.group(1)?.replaceAll('\n', ' ') ?? "No instructions provided.";
    final equipmentsList = equipmentMatches?.group(1)?.split('\n- ') ?? ["Standard bar tools"];

    // creating a Drink object
    Drink newDrink = Drink(
      name: name,
      timeCreated: DateTime.now().toIso8601String(),
      favorite: false,
      instructions: instructions,
      equipments: equipmentsList,
      ingredients: ingredientsList,
    );

    return newDrink;
  }

  Future<Drink> CallGPT() async {
    final dataManager = DataManager();
    //var drinks = await dataManager.getDrinks();
    var currentDrinkRequest = await dataManager.getCurrentDrinkRequest();
    //drinks.forEach(print);
    print(currentDrinkRequest);

    // demo of gpt writing into local json file
    // call getCocktailRecommendation
    String cocktailRecommendation = '';
    cocktailRecommendation = await getCocktailRecommendation(
      ingredients: currentDrinkRequest.ingredients,
      optionalPreferences: currentDrinkRequest.optionalPreferences,
      alcoholStrength: currentDrinkRequest.alcoholStrength,
    );
    print(cocktailRecommendation);
    //store into local json file
    //process the raw string
    Drink drink = processRawStringToDrink(cocktailRecommendation);
    dataManager.addDrink(drink);
    // dataManager.addDrink(drinkData);
    setState(() {
      // rebuild UI based on the data you've loaded
      listViews.clear();
      addAllListData();
    });
    return drink;
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MixyAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MixyAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: MixyAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Mixing Station',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: MixyAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: MixyAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: MixyAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: MixyAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '15 May',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: MixyAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: MixyAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: MixyAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
