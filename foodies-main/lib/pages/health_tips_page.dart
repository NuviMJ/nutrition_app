import 'package:flutter/material.dart';
import 'health_tip_detail_page.dart';

class HealthTip {
  final String title;
  final String description;

  HealthTip({required this.title, required this.description});
}

class HealthTipsPage extends StatefulWidget {
  const HealthTipsPage({super.key});

  @override
  State<HealthTipsPage> createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  List<HealthTip> tips = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchHealthTips();
  }

  Future<void> fetchHealthTips() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      setState(() {
        tips = [
          HealthTip(
            title: "Drink plenty of water.",
            description: "Water regulates body temperature, lubricates joints, and prevents infections.",
          ),
          HealthTip(
            title: "Eat fruits and vegetables daily.",
            description: "They are rich in nutrients, fiber, and antioxidants essential for health.",
          ),
          HealthTip(
            title: "Exercise at least 30 minutes a day.",
            description: "Physical activity strengthens your heart, muscles, and improves mental health.",
          ),
          HealthTip(
            title: "Get 7–8 hours of sleep.",
            description: "Adequate sleep improves memory, immunity, and mood.",
          ),
          HealthTip(
            title: "Wash your hands regularly.",
            description: "Hand hygiene helps prevent the spread of viruses and bacteria.",
          ),
          HealthTip(
            title: "Avoid smoking.",
            description: "Smoking increases the risk of heart disease, cancer, and respiratory problems.",
          ),
          HealthTip(
            title: "Limit alcohol intake.",
            description: "Excessive alcohol can damage the liver and increase disease risk.",
          ),
          HealthTip(
            title: "Practice mindfulness or meditation.",
            description: "It helps reduce stress and improves emotional health.",
          ),
          HealthTip(
            title: "Spend time outdoors in natural sunlight.",
            description: "Sunlight helps your body produce vitamin D.",
          ),
          HealthTip(
            title: "Maintain a healthy weight.",
            description: "Balanced diet and exercise help prevent chronic diseases.",
          ),
          HealthTip(
            title: "Avoid processed and sugary foods.",
            description: "They can lead to obesity, diabetes, and other health issues.",
          ),
          HealthTip(
            title: "Take regular breaks from screens.",
            description: "It helps prevent eye strain and improves mental focus.",
          ),
          HealthTip(
            title: "Maintain good posture.",
            description: "Proper posture prevents back and neck pain.",
          ),
          HealthTip(
            title: "Brush and floss your teeth twice a day.",
            description: "Good oral hygiene prevents gum disease and cavities.",
          ),
          HealthTip(
            title: "Get regular health checkups.",
            description: "Early detection of problems increases treatment success.",
          ),
          HealthTip(
            title: "Practice safe sex.",
            description: "Using protection reduces the risk of STIs and unwanted pregnancies.",
          ),
          HealthTip(
            title: "Stay socially connected.",
            description: "Positive relationships boost happiness and mental health.",
          ),
          HealthTip(
            title: "Keep a regular sleep schedule.",
            description: "Sleeping and waking at consistent times improves rest quality.",
          ),
          HealthTip(
            title: "Stay hydrated during exercise.",
            description: "Replenishing fluids prevents dehydration and muscle fatigue.",
          ),
          HealthTip(
            title: "Seek help when feeling mentally unwell.",
            description: "Talk to a counselor or therapist. Mental health matters too.",
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading tips: $e';
        isLoading = false;
      });
    }
  }

  void openTipDetails(HealthTip tip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HealthTipDetailPage(tip: tip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tips'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : tips.isEmpty
                  ? const Center(child: Text('No health tips available.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: tips.length,
                      itemBuilder: (context, index) {
                        final tip = tips[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(Icons.health_and_safety, color: Colors.teal),
                            title: Text(tip.title, style: const TextStyle(fontSize: 16)),
                            onTap: () => openTipDetails(tip),
                          ),
                        );
                      },
                    ),
    );
  }
}
