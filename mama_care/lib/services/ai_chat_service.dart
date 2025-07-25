import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatService {
  // Google Gemini API key
  static const String apiKey = 'AIzaSyBWV6wDw00uL3p2P_bfuIAybx2H4BXMOt0';
  
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  
  AIChatService() {
    try {
      print('Initializing Gemini AI with API key: ${apiKey.substring(0, 10)}...'); // Debug log
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      _chatSession = _model.startChat();
      print('Gemini AI initialized successfully');
    } catch (e) {
      print('Error initializing Gemini AI: $e');
      // Don't rethrow - let the app continue with mock responses
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      // Create context-aware prompt for maternal health
      final contextualPrompt = _createHealthContextPrompt(message);
      
      print('Sending message to Gemini: $contextualPrompt'); // Debug log
      
      final response = await _chatSession.sendMessage(
        Content.text(contextualPrompt),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out after 30 seconds');
        },
      );
      
      if (response.text != null && response.text!.isNotEmpty) {
        print('Received response from Gemini: ${response.text}'); // Debug log
        return response.text!.trim();
      } else {
        print('Empty response from Gemini API'); // Debug log
        return 'I apologize, but I didn\'t receive a proper response. Please try asking your question again.';
      }
    } catch (e) {
      print('Error in sendMessage: $e'); // Debug log
      print('Error type: ${e.runtimeType}'); // Debug log
      
      // Check if it's an API key issue
      if (e.toString().contains('API_KEY_INVALID') || e.toString().contains('403')) {
        print('API key appears to be invalid or expired');
        return 'I\'m having trouble connecting to my AI service. The API key might be invalid or expired. Using offline responses for now.';
      }
      
      // Try the fallback method
      print('Falling back to mock response');
      return await getMockResponse(message);
    }
  }

  String _createHealthContextPrompt(String userMessage) {
    return '''
You are a helpful assistant specialized in maternal and child health for the Mama Care app. Provide accurate, caring, and supportive information about pregnancy, childbirth, and child care. Always recommend consulting healthcare professionals for medical advice. Keep responses concise but informative, and maintain a warm, supportive tone. Focus on maternal health, pregnancy care, child development, and general wellness.

User question: $userMessage

Please provide helpful, accurate information while being empathetic and supportive. Always remind users to consult healthcare professionals for personalized medical advice.
''';
  }

  // Alternative method for local/mock responses during development
  Future<String> getMockResponse(String message) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('pregnancy') || lowerMessage.contains('pregnant')) {
      return 'During pregnancy, it\'s important to maintain a healthy diet, get regular prenatal checkups, stay hydrated, and get adequate rest. Avoid alcohol, smoking, and certain medications. Always consult your healthcare provider for personalized advice.';
    } else if (lowerMessage.contains('baby') || lowerMessage.contains('infant')) {
      return 'For baby care, ensure regular feeding (breast milk is best for the first 6 months), keep the baby warm and clean, follow vaccination schedules, and watch for any unusual symptoms. Remember, every baby develops at their own pace.';
    } else if (lowerMessage.contains('nutrition') || lowerMessage.contains('food')) {
      return 'Good nutrition is crucial during pregnancy and breastfeeding. Include plenty of fruits, vegetables, whole grains, lean proteins, and dairy. Take prenatal vitamins as recommended by your doctor. Avoid raw or undercooked foods.';
    } else if (lowerMessage.contains('exercise') || lowerMessage.contains('workout')) {
      return 'Moderate exercise during pregnancy can be beneficial, such as walking, swimming, or prenatal yoga. Always consult your doctor before starting any exercise routine during pregnancy. Listen to your body and avoid high-impact activities.';
    } else {
      return 'Thank you for your question about maternal and child health. I\'m here to provide general information and support. For specific medical concerns, please consult with your healthcare provider who can give you personalized advice based on your situation.';
    }
  }
}
