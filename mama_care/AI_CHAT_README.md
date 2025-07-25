# AI-Powered Chat Feature for Mama Care App

## Overview
The Mama Care app now includes an AI-powered chat assistant that helps users get answers to questions about pregnancy, baby care, and maternal health.

## Features
- 🤖 AI-powered responses specialized in maternal and child health
- 💬 Modern chat interface with message bubbles
- 🎨 Consistent design matching the app's pink color scheme
- ⚡ Real-time responses with loading indicators
- 📱 Mobile-optimized UI with smooth scrolling

## How to Access
1. Open the Mama Care app
2. Go to the Home page
3. Scroll down to "Quick Actions" section
4. Tap on "Ask AI Health Assistant" button (purple button with robot icon)

## How to Use
1. Type your question in the text field at the bottom
2. Ask about topics like:
   - Pregnancy symptoms and care
   - Baby feeding and development
   - Nutrition during pregnancy
   - Exercise recommendations
   - General health concerns
3. Tap the send button or press enter
4. The AI will respond with helpful, maternal health-focused information

## Current Implementation
- **Development Mode**: Currently uses mock responses for testing
- **Production Mode**: Ready to connect to AI services like OpenAI, Google Gemini, or others

## Setup for Production AI
To enable real AI responses:

1. **Get an API key** from your preferred AI service:
   - OpenAI GPT
   - Google Gemini
   - Anthropic Claude
   - Azure OpenAI

2. **Update the API key** in `lib/services/ai_chat_service.dart`:
   ```dart
   static const String apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   ```

3. **Switch to real AI responses** in `ai_chat_page.dart`:
   ```dart
   // Change this line:
   final response = await _aiService.getMockResponse(text);
   // To this:
   final response = await _aiService.sendMessage(text);
   ```

## Security Notes
- Store API keys securely in production (use environment variables or secure storage)
- Never commit API keys to version control
- Consider implementing rate limiting for API calls
- Add user authentication checks before allowing AI chat access

## Sample Questions to Try
- "What foods should I eat during pregnancy?"
- "How often should I feed my newborn baby?"
- "What exercises are safe during pregnancy?"
- "When should I call my doctor during pregnancy?"
- "How can I prepare for childbirth?"

## Color Scheme Used
- Primary: Pink/Pink Accent (matching app theme)
- Secondary: Deep Purple (for accents and icons)
- User messages: Pink shade
- AI messages: Light grey
- Background: White with subtle shadows

The AI chat feature is designed to provide helpful, supportive information while always encouraging users to consult healthcare professionals for personalized medical advice.
