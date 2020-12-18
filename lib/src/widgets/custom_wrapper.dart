import 'package:flutter/material.dart';
import 'package:myapp/src/utils/Constant.dart';

class CustomWrapper extends StatefulWidget {
  final Widget child;

  const CustomWrapper({Key key, this.child}) : super(key: key);

  @override
  _CustomWrapperState createState() => _CustomWrapperState();
}

class _CustomWrapperState extends State<CustomWrapper>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _animateController;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _animateController = AnimationController(vsync: this, duration: duration);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(_animateController);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_animateController);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_animateController);

    super.initState();
  }

  @override
  void dispose() {
    _animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {





    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Stack(
      children: <Widget>[
        CustomDrawer(
          menuScaleAnimation: _menuScaleAnimation,
          slideAnimation: _slideAnimation,
        ),
        _buildCollapse()
      ],
    );
  }

  _buildCollapse() => AnimatedPositioned(
    duration: duration,
    top: 0,
    bottom: 0,
    left: isCollapsed ? 0 : 0.6 * screenWidth,
    right: isCollapsed ? 0 : -0.2 * screenWidth,
    child: ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        animationDuration: duration,
        borderRadius:
        isCollapsed ? null : BorderRadius.all(Radius.circular(40)),
        elevation: 8,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        if (isCollapsed) {
                          _animateController.forward();
                        } else {
                          _animateController.reverse();
                        }
                        isCollapsed = !isCollapsed;
                      });
                    },
                  ),
                  Text(
                    "Scan Barcode",
                    style: TextStyle(fontSize: 24,fontFamily: 'KanitRegular'),
                  ),
//                  SizedBox(width: 30),
                ],
              ),
            ),
            Expanded(
              child: isCollapsed
                  ? widget.child
                  : Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: widget.child,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  final Animation<double> menuScaleAnimation;
  final Animation<Offset> slideAnimation;

  const CustomDrawer({Key key, this.menuScaleAnimation, this.slideAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 130, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildAvatar(),
              ..._buildName(),
              SizedBox(height: 40),
              ..._buildList(context),
              Spacer(),
              _buildLogout(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    return <Widget>[
      InkWell(
        onTap: () {
          //todo
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.person,
              ),
              SizedBox(width: 12),
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 20,fontFamily: 'KanitRegular'
                ),
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          //todo
          Navigator.pushReplacementNamed(context, Constant.MAP_ROUTE);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.map,
              ),
              SizedBox(width: 12),
              Text(
                "Map",
                style: TextStyle(
                  fontSize: 20,fontFamily: 'KanitRegular'
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Container _buildAvatar() {
    return Container(
      width: 110,
      height: 110,
      margin: EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Gatto_europeo4.jpg/1200px-Gatto_europeo4.jpg"),
      ),
    );
  }

  List<Widget> _buildName() {
    return <Widget>[
      Text(
        "iBlurBlur",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
      ),
      Text(
        "Bangkok, Thailand",
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    ];
  }

  InkWell _buildLogout() {
    return InkWell(
      onTap: () {
        //todo
      },
      child: Padding(
        padding: EdgeInsets.only(right: 130, top: 12, bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}