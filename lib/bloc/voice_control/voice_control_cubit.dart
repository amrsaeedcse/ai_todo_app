import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_model.dart';

part 'voice_control_state.dart';

class VoiceControlCubit extends Cubit<VoiceControlState> {
  VoiceControlCubit() : super(VoiceControlInitial());

  Future getAiTodo(String text) async {
    try {
      emit(VoiceControlLoading());
      TodoModel todoModel = await getAiModel(text);
      emit(VoiceControlSuccess(todoModel));
    } catch (e) {
      emit(VoiceControlError(e.toString()));
    }
  }
}

Future<TodoModel> getAiModel(String text) async {
  const String apiKey = "AIzaSyCO3LkX8MkfSJAZazbHoRnVmhG1iWFgk1Q";

  // try {
  final response = await Dio().post(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
    data: {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "You are an assistant that extracts task information and always returns it as a JSON object with these exact keys: todoName (String), finishTime (ISO 8601 datetime String), finished (boolean), disc (String).Rules:- If any information is not mentioned, leave that field empty ("
                  ") or null- For finishTime: if no time is mentioned, use empty string "
                  "- For finished: default to false if not specified- For disc: if no description, use empty string "
                  "- Do not return any explanation, only the JSON.Convert this text into a TodoModel JSON: $text , and always write a titile",
            },
          ],
        },
      ],
      "generationConfig": {"temperature": 0, "maxOutputTokens": 256},
    },
    options: Options(headers: {"Content-Type": "application/json"}),
  );

  if (response.statusCode == 200) {
    final result =
        response.data["candidates"][0]["content"]["parts"][0]["text"];
    print("Gemini Response: $result");

    try {
      String cleanResult = result.trim();
      if (cleanResult.startsWith('```json')) {
        cleanResult = cleanResult.substring(7);
      }
      if (cleanResult.endsWith('```')) {
        cleanResult = cleanResult.substring(0, cleanResult.length - 3);
      }
      cleanResult = cleanResult.trim();

      final Map<String, dynamic> jsonData = jsonDecode(cleanResult);
      final todo = TodoModel.fromJson(jsonData);

      print("Parsed Todo:");
      print("Name: ${todo.todoName}");
      print("Finish Time: ${todo.finishTime}");
      print("Finished: ${todo.finished}");
      print("Description: ${todo.disc}");
      return todo;
    } catch (e) {
      throw Exception("Error while parsing");
      print("Error parsing JSON: $e");
      print("Raw response: $result");
    }
  } else {
    throw Exception("Error: ${response.statusCode}");

    print("Error: ${response.statusCode}");
    print("Response: ${response.data}");
  }
  // } catch (e) {
  //   throw Exception("Error: Network");
  // }
}
