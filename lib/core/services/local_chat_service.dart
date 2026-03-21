import 'dart:math';

class LocalChatService {
  final Map<String, List<String>> _responses = {
    'fish': [
      "Hello! I am the Ocevara Marine Expert. I can certainly help you identify various species. Are you currently looking for details on common species like Tilapia and Carp, or perhaps more regulated ones like the Juvenile Snapper?",
      "Welcome to our marine database. Identification is a key part of sustainable fishing. Which specific species are you observing today? I can provide detailed characteristics and regulations.",
      "Greetings! To ensure accurate identification, I recommend observing the scale patterns and dorsal fin structure. What kind of fish have you encountered?"
    ],
    'time': [
      "For the most productive experience, I recommend fishing during the 'Golden Hours'—early morning or late evening. This is when water temperatures are optimal and aquatic activity is at its peak.",
      "Weather patterns significantly influence marine behavior. Overcast conditions often provide superior results compared to direct sunlight. I suggest monitoring local forecasts for the best timing.",
      "Tides play a crucial role in coastal ecosystems. Fishing during tide changes often yields excellent results. Are you currently near a tidal zone?"
    ],
    'bait': [
      "Excellent question. For freshwater species like Tilapia or Carp, organic baits such as worms, processed corn, or specialized dough balls are highly effective.",
      "When targeting larger predators like the Nile Perch, I recommend using large lures that mimic local prey or fresh live bait for the best strike rate.",
      "Precision is key in angling. Ensure your equipment is well-maintained and your hooks are appropriately sized for the species you are targeting."
    ],
    'safety': [
      "Safety is our top priority. Please ensure you are wearing a certified personal flotation device whenever you are on a vessel or near deep currents.",
      "To protect our marine heritage, please review the 'Rules' section of the Ocevara app. Adhering to local regulations ensures a sustainable future for all fishers.",
      "Remember to stay hydrated and use appropriate sun protection. The marine environment can be demanding over long periods."
    ],
    'ocevara': [
      "Ocevara AI is your dedicated partner in sustainable fishing. Our goal is to provide you with expert-level knowledge to enhance your experience while protecting our oceans.",
      "You can utilize the integrated Map to identify sustainable zones, or consult the Species Calendar for seasonal insights and local restrictions.",
      "We recommend exploring the 'Fish List' for in-depth biological data and conservation status on hundreds of local species."
    ],
    'default': [
      "Thank you for your inquiry. While I am Currently operating in offline mode with limited data, I can still provide professional guidance on general fishing principles. How else may I assist you today?",
      "That is an interesting topic. As your Ocevara Marine Expert, I am committed to providing you with the best information possible. Could you provide a few more details so I can assist you better?",
      "I am here to support your fishing journey with professional insights. Feel free to ask about specific techniques, species biology, or conservation practices."
    ]
  };

  String getResponse(String userMessage) {
    final msg = userMessage.toLowerCase();
    
    if (msg.contains('time') || msg.contains('when')) {
      return _getRandomResponse('time');
    } else if (msg.contains('bait') || msg.contains('lure') || msg.contains('how to catch')) {
      return _getRandomResponse('bait');
    } else if (msg.contains('safety') || msg.contains('rule') || msg.contains('legal')) {
      return _getRandomResponse('safety');
    } else if (msg.contains('fish') || msg.contains('species') || msg.contains('tilapia')) {
      return _getRandomResponse('fish');
    } else if (msg.contains('app') || msg.contains('ocevara')) {
      return _getRandomResponse('ocevara');
    }
    
    return _getRandomResponse('default');
  }

  String _getRandomResponse(String category) {
    final list = _responses[category] ?? _responses['default']!;
    return list[Random().nextInt(list.length)];
  }
}
