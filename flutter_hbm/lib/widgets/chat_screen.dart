import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/services/chat_recommendation_service.dart';
import 'package:provider/provider.dart';

import '../screens/provider/user_provider.dart';

class ChatScreenWidget extends StatefulWidget {
  const ChatScreenWidget({super.key});

  @override
  ChatScreenWidgetState createState() => ChatScreenWidgetState();
}

class ChatScreenWidgetState extends State<ChatScreenWidget> {
  String selectedCategory = "";
  final TextEditingController textController = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      greetings();
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void greetings() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      messages.add({
        "sender": "bot",
        "text": "Hello, ${userProvider.firstName}! How can I be helpful to you?"
            " You can select one of the categories, down bellow ⬇."
      });
    });
  }

  Future<void> getMessage(String userMessage) async {
    if (userMessage.isEmpty) return;
    setState(() {
      messages.add({"sender": "user", "text": userMessage});
    });
    try {
      String response = await ChatRecommendationService.getDialogFlowAnswer(userMessage);
      setState(() {
        messages.add({"sender": "bot", "text": response});
      });
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "text": e.toString()});
      });
    }
  }

  final Map<String, List<String>> categoryQuestions = {
    "Protein": [
      "Why is protein important?",
      "How does protein contribute to overall health and well-being?",
      "How do I calculate my daily protein intake?",
      "How many calories does one gram of protein contain?",
    ],
    "Carbs": [
      "What is the importance of carbohydrates?",
      "What is the role of carbohydrates in energy and performance?",
      "How do I calculate my daily carbs intake?",
      "How many calories are in one gram of carbohydrates?"
    ],
    "Fats": [
      "How do fats help in overall health?",
      "Why do we need fats in our diet?",
      "What is the recommended daily intake of fats?",
      "How much fat should I eat per day?",
      "How many calories are in fat?"
    ],
    "Calories": [
      "What are calories?",
      "How do I calculate my daily caloric needs?",
      "How do calories relate to weight loss?",
      "How do calories relate to weight gain?"
    ],
    "Diets": [
      "Why is a diet important?",
      "What is the keto diet?",
      "Tell me about a vegan diet?",
      "How does the Mediterranean diet help health?"
    ],
    "Training": [
      "How do I build strength and muscle mass?",
      "How do I train to gain muscle?",
      "How should I train to lose weight?",
      "What is the best exercise for weight loss?",
      "How can I improve my general fitness level?"
    ],
    "Water": [
      "What are the benefits of drinking water?",
      "How does drinking water affect my health?",
      "Why is water important for the body?",
      "How much water should I drink each day?"
    ]
  };

  Widget buildCategoryButtons() {
    List<String> categories = categoryQuestions.keys.toList();

    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = category;
            });
          },
          child: Text(category),
        );
      }).toList(),
    );
  }

  Widget buildQuickReplyButtons() {
    if (selectedCategory.isEmpty) {
      return buildCategoryButtons();
    }

    List<String> quickReplies = categoryQuestions[selectedCategory] ?? [];

    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          children: quickReplies.map((text) {
            return ElevatedButton(
              onPressed: () {
                getMessage(text);
              },
              child: Text(text),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = "";
            });
          },
          child: Text("⬅ Back"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HealthyBot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['sender'] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['sender'] == "user"
                          ? Colors.grey[300]
                          : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['text']!),
                  ),
                );
              },
            ),
          ),
          buildQuickReplyButtons(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(hintText: "Ask HealthyBot for help"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      getMessage(textController.text);
                      textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}