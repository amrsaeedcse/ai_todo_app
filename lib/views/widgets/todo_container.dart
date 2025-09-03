import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_control/todo_control_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoContainer extends StatefulWidget {
  const TodoContainer({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnim;
  bool showShowMore = false;
  bool isLong = false;
  double height = 60;
  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    sizeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );
    animationController.forward();
    if (widget.todoModel.todoName.length > 16) {
      showShowMore = true;
      isLong = true;
    }

    super.initState();
  }

  double _calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    print(textPainter.size.height);

    return textPainter.size.height + 20;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: SizeTransition(
        sizeFactor: sizeAnim,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.secondaryBackGround,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  activeColor: AppColors.buttonColor,
                  splashRadius: 20,
                  side: BorderSide(color: AppColors.onPrimaryText, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4),
                    side: BorderSide(
                      color: AppColors.onPrimaryText,
                      width: 1.2,
                    ),
                  ),
                  value: widget.todoModel.selected,

                  onChanged: (value) {
                    context.read<TodoControlCubit>().selectIt(widget.todoModel);
                  },
                ),
              ),
              Expanded(
                child: CustomText(
                  text: widget.todoModel.todoName,
                  fontWeight: FontWeight.w500,
                  size: 20,
                  isLined: widget.todoModel.selected,
                  oneLine: showShowMore,
                ),
              ),

              isLong
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          showShowMore = !showShowMore;
                          if (height == 60) {
                            height = _calculateTextHeight(
                              widget.todoModel.todoName,
                              TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              MediaQuery.sizeOf(context).width - 120,
                            );
                            return;
                          }
                          height = 60;
                        });
                      },
                      child: CustomText(
                        text: showShowMore ? "showMore" : "showLess",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: AppColors.buttonColor,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
