import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealsWeekPage extends StatelessWidget {
  const MealsWeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Meal Plan')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('weekly_meal_plans')
            .orderBy('day_order')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No meal plans available yet.'));
          }

          final daysPlan = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: daysPlan.length,
            itemBuilder: (context, index) {
              final dayData = daysPlan[index].data() as Map<String, dynamic>;

              final String dayOfWeek =
                  dayData['day_of_week'] as String? ?? 'Unknown Day';
              final String breakfast =
                  dayData['breakfast'] as String? ?? 'Not specified';
              final String lunch =
                  dayData['lunch'] as String? ?? 'Not specified';
              final String dinner =
                  dayData['dinner'] as String? ?? 'Not specified';

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    child:
                        Text((dayData['day_order'] as num? ?? index + 1).toString()),
                  ),
                  title: Text(
                    dayOfWeek,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.wb_sunny_outlined,
                          color: Colors.orangeAccent),
                      title: const Text('Breakfast'),
                      subtitle: Text(breakfast),
                    ),
                    ListTile(
                      leading: const Icon(Icons.fastfood_outlined,
                          color: Colors.redAccent),
                      title: const Text('Lunch'),
                      subtitle: Text(lunch),
                    ),
                    ListTile(
                      leading: const Icon(Icons.nights_stay_outlined,
                          color: Colors.indigoAccent),
                      title: const Text('Dinner'),
                      subtitle: Text(dinner),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final dayController = TextEditingController();
    final breakfastController = TextEditingController();
    final lunchController = TextEditingController();
    final dinnerController = TextEditingController();
    final dayOrderController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Form(
          key: formKey,
          child: Wrap(
            children: [
              const Text(
                "Add Meal Plan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dayOrderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Day Order (1-7)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter day order';
                  return null;
                },
              ),
              TextFormField(
                controller: dayController,
                decoration: const InputDecoration(labelText: 'Day of Week'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter day name';
                  return null;
                },
              ),
              TextFormField(
                controller: breakfastController,
                decoration: const InputDecoration(labelText: 'Breakfast'),
              ),
              TextFormField(
                controller: lunchController,
                decoration: const InputDecoration(labelText: 'Lunch'),
              ),
              TextFormField(
                controller: dinnerController,
                decoration: const InputDecoration(labelText: 'Dinner'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('weekly_meal_plans')
                        .add({
                      'day_order': int.tryParse(dayOrderController.text) ?? 1,
                      'day_of_week': dayController.text.trim(),
                      'breakfast': breakfastController.text.trim(),
                      'lunch': lunchController.text.trim(),
                      'dinner': dinnerController.text.trim(),
                    });
                    Navigator.of(ctx).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
