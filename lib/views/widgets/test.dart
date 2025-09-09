import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

class TodoSearchMorphPage extends StatefulWidget {
  @override
  _TodoSearchMorphPageState createState() => _TodoSearchMorphPageState();
}

class _TodoSearchMorphPageState extends State<TodoSearchMorphPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _iconKey = GlobalKey();

  late AnimationController _controller;
  bool _floatingVisible = false; // floating icon during animation
  bool _expanded = false; // whether morph to TextField happened
  bool _showAppBarIcon = true; // hide original icon when floating

  // positions and sizes (set on tap)
  late double _startLeft;
  late double _startTop;
  late double _targetLeft;
  late double _targetTop;
  double _floatingSize = 50;
  double _expandedWidth = 0;

  // list top padding to simulate "push" of first item
  double _listTopPadding = 8;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addListener(() {
            // update list padding while animating (push effect)
            setState(() {
              _listTopPadding = lerpDouble(
                8,
                72,
                Curves.easeInOut.transform(_controller.value),
              )!;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // arrived: morph to expanded search bar
              setState(() {
                _expanded = true;
              });
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // When tapping the appbar icon
  Future<void> _onSearchTap() async {
    // measure positions inside the Stack coordinate space
    final stackBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final iconBox = _iconKey.currentContext!.findRenderObject() as RenderBox;

    final iconGlobal = iconBox.localToGlobal(Offset.zero);
    final stackGlobal = stackBox.localToGlobal(Offset.zero);
    final startLocal = iconGlobal - stackGlobal;

    // target: a little margin from left and just below the "appbar"
    final double leftMargin = 16;
    final double targetTop = kToolbarHeight + 12; // where search bar will sit

    setState(() {
      _startLeft = startLocal.dx;
      _startTop = startLocal.dy;
      _targetLeft = leftMargin;
      _targetTop = targetTop;
      _expandedWidth = stackBox.size.width - leftMargin * 2;
      _floatingVisible = true;
      _showAppBarIcon = false;
      _expanded = false;
    });

    // start animation (icon flies down & list pushes)
    await _controller.forward(from: 0.0);
    // after forward, _expanded becomes true in status listener -> AnimatedContainer will expand
  }

  // Close search (reverse animations)
  Future<void> _closeSearch() async {
    // first shrink the search bar to circle
    setState(() {
      _expanded = false;
    });

    // wait for width shrink animation (same duration as AnimatedContainer below)
    await Future.delayed(Duration(milliseconds: 300));

    // reverse the flying animation
    await _controller.reverse();
    setState(() {
      _floatingVisible = false;
      _showAppBarIcon = true;
      _listTopPadding = 8;
    });
  }

  // compute current position of floating object during animation
  Offset _currentFloatingOffset() {
    if (!_floatingVisible) return Offset.zero;
    final t = Curves.easeInOut.transform(_controller.value);
    final dx = lerpDouble(_startLeft, _targetLeft, t)!;
    final dy = lerpDouble(_startTop, _targetTop, t)!;
    return Offset(dx, dy);
  }

  // width of floating element (circle -> expanded bar)
  double _currentFloatingWidth() {
    if (!_floatingVisible) return _floatingSize;
    if (!_expanded) return _floatingSize;
    return _expandedWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // note: we're making our own "app bar" inside the Stack to keep coordinate space simple
      body: SafeArea(
        child: Stack(
          key: _stackKey,
          children: [
            // top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: kToolbarHeight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      "My Todos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    // original icon (we hide it while floating)
                    if (_showAppBarIcon)
                      GestureDetector(
                        key: _iconKey,
                        onTap: _onSearchTap,
                        child: Container(
                          width: _floatingSize,
                          height: _floatingSize,
                          alignment: Alignment.center,
                          child: Icon(Icons.search, size: 26),
                        ),
                      )
                    else
                      SizedBox(width: _floatingSize),
                  ],
                ),
              ),
            ),

            // the list (with Animated padding on top to show the "push" effect)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedPadding(
                duration: Duration(milliseconds: 120),
                padding: EdgeInsets.only(top: _listTopPadding),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    // Make first item visually where search will stop for better illusion
                    return _todoTile(
                      title: index == 0 ? "first todo" : "todo $index",
                      checked: index % 2 == 0,
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemCount: 8,
                ),
              ),
            ),

            // floating widget (icon -> moves -> morphs into textfield)
            if (_floatingVisible)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final pos = _currentFloatingOffset();
                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: _buildFloating(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloating() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _currentFloatingWidth(),
      height: _floatingSize,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: _expanded ? _buildSearchField() : _buildCircleIcon(),
    );
  }

  Widget _buildCircleIcon() {
    return InkWell(
      onTap: () {
        // If user taps floating circle while moving or before morph complete, we can open/close
        if (_controller.status == AnimationStatus.completed) {
          setState(() {
            _expanded = true;
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.search, color: Colors.white)],
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Icon(Icons.search, color: Colors.white),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        GestureDetector(
          onTap: _closeSearch,
          child: Icon(Icons.close, color: Colors.white),
        ),
      ],
    );
  }

  Widget _todoTile({required String title, bool checked = false}) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Checkbox(value: checked, onChanged: (_) {}),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                decoration: checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
    );
  }
}
