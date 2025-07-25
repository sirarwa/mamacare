import 'package:mama_care/services/ai_chat_service.dart';

void main() async {
  print('Testing AI Chat Service...');
  
  final aiService = AIChatService();
  
  try {
    print('Sending test message...');
    final response = await aiService.sendMessage('What should I eat during pregnancy?');
    print('Response received: $response');
  } catch (e) {
    print('Error: $e');
    
    // Try mock response as fallback
    print('Testing mock response...');
    final mockResponse = await aiService.getMockResponse('What should I eat during pregnancy?');
    print('Mock response: $mockResponse');
  }
}
