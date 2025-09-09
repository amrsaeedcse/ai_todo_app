import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/bloc/voice_control/voice_control_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_snack_bar.dart';

import '../../models/todo_model.dart';
import '../../notification.dart';

class Mice extends StatefulWidget {
  Mice({super.key});

  @override
  State<Mice> createState() => _MiceState();
}

class _MiceState extends State<Mice> {
  late stt.SpeechToText _speech;

  bool _isListening = false;

  String _text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  double _confidence = 0;

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (errorNotification) {
          print("error ${errorNotification}");
        },
        onStatus: (status) async {
          print("stat is $status");
          if (status == "done") {
            if (_text.isNotEmpty) {
              setState(() {
                _confidence = 0;
              });
              context.read<VoiceControlCubit>().getAiTodo(_text);
              _text = "";
            }
            setState(() {
              _isListening = false;
            });
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          localeId: "ar_EG",
          // listenFor: Duration(seconds: 10),
          // pauseFor: Duration(seconds: 3),
          pauseFor: Duration(seconds: 100),
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          onResult: (result) {
            _text = result.recognizedWords;
            print(_text);
            if (result.hasConfidenceRating && result.confidence > 0) {
              print(_confidence);
            }
          },
          onSoundLevelChange: (level) {
            setState(() {
              _confidence = level;
            });
          },
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceControlCubit, VoiceControlState>(
      listener: (context, state) {
        print(state);
        if (state is VoiceControlSuccess) {
          if (state.todoModel.todoName.isEmpty ||
              state.todoModel.disc.isEmpty ||
              state.todoModel.finishTime == null) {
            context.read<TodoListCubit>().addTempTodo(state.todoModel);
          } else {
            context.read<TodoListCubit>().addTodo(state.todoModel);
            try {
              scheduleTodoReminders(
                finishTime: state.todoModel.finishTime!,
                taskName: state.todoModel.todoName,
              );
              print("ok it sheduled");
            } catch (e) {
              print(e.toString());
            }
          }
        } else if (state is VoiceControlError) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        double safeConfidence = _confidence.clamp(0.0, 1.0);

        double minSize = 60;
        double maxSize = 100;
        double size = minSize + (safeConfidence * (maxSize - minSize));
        double opacity = 0.2 + (safeConfidence * 0.8);

        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.elasticOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(opacity),
          ),
          child: FloatingActionButton(
            backgroundColor: AppColors.buttonColor,
            onPressed: _isListening ? () {} : listen,
            child: state is VoiceControlLoading
                ? CupertinoActivityIndicator(
                    color: AppColors.secondaryBackGround,
                  )
                : Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: AppColors.secondaryBackGround,
                  ),
          ),
        );
      },
    );
  }
}
