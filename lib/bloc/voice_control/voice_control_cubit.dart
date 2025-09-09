import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_model.dart';

import '../../secrets.dart';

part 'voice_control_state.dart';

class VoiceControlCubit extends Cubit<VoiceControlState> {
  VoiceControlCubit() : super(VoiceControlInitial());

  Future getAiTodo(String text) async {
    try {
      emit(VoiceControlLoading());
      TodoModel todoModel = await getAiModel(text);
      emit(VoiceControlSuccess(todoModel));
    } catch (e) {
      if (e.toString().contains("Error: Network")) {
        emit(VoiceControlError("No Internet"));
      } else {
        emit(VoiceControlError(e.toString()));
      }
    }
  }
}

Future<TodoModel> getAiModel(String text) async {
  const String apiKey = googleApiKey;

  try {
    String today = DateTime.now().toUtc().toIso8601String();

    final response = await Dio().post(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
      data: {
        "contents": [
          {
            "parts": [
              {
                "text":
                    // "You are an assistant that extracts task information and always returns it as a JSON object with these exact keys: todoName (String), finishTime (ISO 8601 datetime String), finished (boolean), disc (String).Rules:- If any information is not mentioned, leave that field empty ("
                    // ") or null- For finishTime: if no time is mentioned, use empty string ."
                    // "If I don’t mention the month → assume it is the current month"
                    // "   If I don’t mention the year → assume it is the current year."
                    // "If the date I provide is in the past compared to today → set it to empty (don’t accept it)"
                    // "If the date I provide is in the past compared to today → set it to empty (don’t accept it)"
                    // "- - Always respond in English only"
                    // "- Make sure the title is one or two words"
                    // "For finishTime: if no time is mentioned, use empty string. If not empty, make sure it is in the future."
                    // "- Do not return any explanation, only the JSON.Convert this text into a TodoModel JSON: $text , and always write a titile",
                    "You are an assistant that extracts task information and always returns it as a JSON object with these exact keys: todoName (String), finishTime (ISO 8601 datetime String), finished (boolean), disc (String). Rules: If any information is not mentioned, leave that field empty (\"\") or null. For finishTime: If no time is mentioned → use empty string. If I don’t mention the month → assume it is the current month. If I don’t mention the year → assume it is the current year. If the date I provide is in the past compared to today ($today) → set it to empty (don’t accept it). If not empty, make sure it is in the future. Always respond in English only. Make sure the title (todoName) is one or two words. Do not return any explanation, only the JSON. Convert this text into a TodoModel JSON: $text",
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
  } catch (e) {
    throw Exception("Error: Network");
  }
}
