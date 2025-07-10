import 'package:flutter/material.dart';

class ClinicsPage extends StatelessWidget {
  const ClinicsPage({super.key});

  final List<Map<String, String>> _clinics = const [
    {
      'name': 'Rural Health Clinic A',
      'location': 'Kajiado, Kenya',
      'services': 'Maternal, Child Health, Vaccinations',
      'phone': '+254712345678',
    },
    {
      'name': 'Community Dispensary B',
      'location': 'Machakos, Kenya',
      'services': 'Basic Checkups, Family Planning',
      'phone': '+254723456789',
    },
    {
      'name': 'Mama Pendo Clinic',
      'location': 'Kisumu, Kenya',
      'services': 'Antenatal, Postnatal, Delivery',
      'phone': '+254734567890',
    },
    {
      'name': 'Hope Medical Center',
      'location': 'Kakamega, Kenya',
      'services': 'Comprehensive Maternal Care',
      'phone': '+254745678901',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearby Clinics',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _clinics.length,
              itemBuilder: (context, index) {
                final clinic = _clinics[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinic['name']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                clinic['location']!,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.info, size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Services: ${clinic['services']!}',
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Call: ${clinic['phone']!}',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Placeholder for actual map integration
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Locating ${clinic['name']} on map... (Feature to be implemented)')),
                              );
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Locate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}