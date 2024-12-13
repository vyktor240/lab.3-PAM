import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorHomePage(),
    );
  }
}

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  Future<List<dynamic>> loadDoctors() async {
    String jsonString = await rootBundle.loadString('assets/doctors.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }

  Future<List<dynamic>> loadMedicalCenters() async {
    String jsonString = await rootBundle.loadString('assets/medical_centers.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Găsește-ți Doctorul', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 16),
        ],
        leading: const Icon(Icons.location_on, color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Locație
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Seattle, SUA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              const SizedBox(height: 16),

              // Bara de căutare
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Caută doctor...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Secțiunea specialiști
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green[100],
                ),
                child: Row(
                  children: <Widget>[
                    // Prevenirea depășirii spațiului
                    Expanded(
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cauți doctori specialiști?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Programează o întâlnire cu cei mai buni doctori ai noștri.'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Imagine ajustată
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Categorii
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categorii',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Vezi tot'),
                ],
              ),
              const SizedBox(height: 16),

              // Grid pentru Categorii
              GridView.count(
                shrinkWrap: true, // Important pentru a evita eroarea de depășire
                physics: const NeverScrollableScrollPhysics(), // Previne scroll-ul intern
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  CategoryIcon(label: 'Stomatologie', icon: Icons.medical_services),
                  CategoryIcon(label: 'Cardiologie', icon: Icons.favorite),
                  CategoryIcon(label: 'Pneumologie', icon: Icons.air),
                  CategoryIcon(label: 'General', icon: Icons.person),
                  CategoryIcon(label: 'Neurologie', icon: Icons.psychology),
                  CategoryIcon(label: 'Gastro', icon: Icons.local_hospital),
                  CategoryIcon(label: 'Laborator', icon: Icons.biotech),
                  CategoryIcon(label: 'Vaccinare', icon: Icons.vaccines),
                ],
              ),
              const SizedBox(height: 16),

              // Centre medicale apropiate
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Centre Medicale Apropiate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Vezi tot'),
                ],
              ),
              const SizedBox(height: 16),

              // ListView orizontal pentru centre medicale
              FutureBuilder<List<dynamic>>(
                future: loadMedicalCenters(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Eroare la încărcarea centrelor medicale.');
                  } else {
                    final medicalCenters = snapshot.data!;
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: medicalCenters.length,
                        itemBuilder: (context, index) {
                          final center = medicalCenters[index];
                          return MedicalCenterCard(
                            name: center['name'],
                            address: center['address'],
                            rating: center['rating'],
                            reviews: center['reviews'],
                            distance: center['distance'],
                            time: center['time'],
                            imageUrl: center['imageUrl'],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Secțiunea Top Doctori
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Doctori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Vezi tot'),
                ],
              ),
              const SizedBox(height: 16),

              // Lista Doctorilor
              FutureBuilder<List<dynamic>>(
                future: loadDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Eroare la încărcarea doctorilor.');
                  } else {
                    final doctors = snapshot.data!;
                    return Column(
                      children: doctors.map((doctor) {
                        return DoctorListItem(
                          imageUrl: doctor['imageUrl'],
                          name: doctor['name'],
                          specialty: doctor['specialty'],
                          location: doctor['location'],
                          rating: doctor['rating'],
                          reviews: doctor['reviews'],
                        );
                      }).toList(),
                    );
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

// Icon pentru categorie
class CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryIcon({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12), // Padding ajustat
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueGrey[50],
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Card pentru centru medical
class MedicalCenterCard extends StatelessWidget {
  final String name;
  final String address;
  final double rating;
  final int reviews;
  final String distance;
  final String time;
  final String imageUrl;

  const MedicalCenterCard({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Lățime consistentă
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12), // Padding ajustat
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Imagine cu colțuri rotunjite
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$rating ★ ($reviews Recenzii)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '$distance / $time',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Element listă doctor
class DoctorListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;

  const DoctorListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Imaginea doctorului cu colțuri rotunjite
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Expanded pentru a preveni depășirea
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis, // Gestionarea depășirii textului
                ),
                Text(
                  specialty,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews recenzii)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
