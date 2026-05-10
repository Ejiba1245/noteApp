import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/app_strings.dart';
import 'dart:io';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = Platform.environment[AppStrings.geminiApiKey] ?? '';
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String?> summarizeNote(String content) async {
    final prompt = 'Summarize the following note concisely:\n\n$content';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  Future<String?> generateTitle(String content) async {
    final prompt = 'Generate a short, catchy title for this note:\n\n$content';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.replaceAll('"', '').trim();
  }

  Future<List<String>> extractKeywords(String content) async {
    final prompt = 'Extract up to 5 important keywords from this note as a comma-separated list:\n\n$content';
    final response = await _model.generateContent([Content.text(prompt)]);
    if (response.text == null) return [];
    return response.text!.split(',').map((e) => e.trim()).toList();
  }

  Future<String?> askAI(String question, String context) async {
    final prompt = 'Context from notes: $context\n\nQuestion: $question';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
