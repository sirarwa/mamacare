import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Welcome to Mama Care!'),
          _buildInfoCard(
            'Stay Healthy During Pregnancy',
            'Eat a balanced diet, get regular exercise, and ensure you get enough rest. Avoid smoking and alcohol.',
            Icons.favorite,
            Colors.redAccent,
          ),
          _buildInfoCard(
            'Baby Care Tips',
            'Ensure your baby is well-fed, kept warm, and has a clean environment. Regular checkups are crucial.',
            Icons.child_care,
            Colors.blueAccent,
          ),
          _buildInfoCard(
            'Importance of Antenatal Care',
            'Regular visits to a healthcare provider during pregnancy can help monitor your health and your baby\'s development, detecting potential issues early.',
            Icons.medical_services,
            Colors.greenAccent,
          ),
          _buildSectionTitle('Quick Actions'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(context, 'Set Reminder', Icons.alarm_add, () {
                // Navigate to Reminders page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Reminders')),
                );
              }),
              _buildActionButton(context, 'Find Clinic', Icons.location_on, () {
                // Navigate to Clinics page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Clinics')),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Featured Partnerships'),
          _buildPartnershipAd(
            'Healthy Baby Products',
            'Discover the best products for your baby\'s growth and well-being. Click here for exclusive discounts!',
            '[https://placehold.co/100x100/FFC0CB/FFFFFF?text=Ad](https://placehold.co/100x100/FFC0CB/FFFFFF?text=Ad)',
          ),
          _buildPartnershipAd(
            'Affordable Health Insurance',
            'Get comprehensive maternal and child health insurance plans tailored for rural communities.',
            '[https://placehold.co/100x100/ADD8E6/000000?text=Insurance](https://placehold.co/100x100/ADD8E6/000000?text=Insurance)',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade300,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnershipAd(String title, String description, String imageUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.pink.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
