import 'package:flutter/material.dart';

import '../models/doctor.dart';

/// A medical specialty shown in the Home screen category grid.
class Specialty {
  const Specialty(this.name, this.icon);

  final String name;
  final IconData icon;
}

/// Order here drives the category grid AND the filter chips.
const List<Specialty> kSpecialties = <Specialty>[
  Specialty('Cardiologist', Icons.favorite_outline),
  Specialty('Dermatologist', Icons.spa_outlined),
  Specialty('Dentist', Icons.medical_services_outlined),
  Specialty('Child Specialist', Icons.child_care_outlined),
  Specialty('Neurologist', Icons.psychology_outlined),
  Specialty('Orthopedic', Icons.accessibility_new_outlined),
];

/// Static demo doctors.
///
/// `availableDays` uses Dart weekday numbers: Mon = 1 ... Sun = 7.
/// Values are deliberately varied so the day filter and the daily-limit logic
/// are both visible during the demo.
const List<Doctor> kDemoDoctors = <Doctor>[
  Doctor(
    id: 'd1',
    name: 'Dr. Srijon Roy',
    specialty: 'Cardiologist',
    hospital: 'Popular Diagnostic Centre, Sylhet',
    rating: 4.8,
    experienceYears: 12,
    fee: 1000,
    bio:
        'Consultant Cardiologist with over a decade of experience in interventional '
        'cardiology, hypertension management and preventive heart care.',
    availableDays: <int>[1, 3, 5],
    startHour: 17,
    startMinute: 0,
    consultMinutes: 15,
    dailyLimit: 20,
  ),
  Doctor(
    id: 'd2',
    name: 'Dr. Sadia Rahman',
    specialty: 'Dermatologist',
    hospital: 'Mount Adora Hospital, Akhalia',
    rating: 4.7,
    experienceYears: 8,
    fee: 800,
    bio:
        'Skin, hair and nail specialist focusing on acne management, eczema and '
        'cosmetic dermatology procedures.',
    availableDays: <int>[2, 4, 6],
    startHour: 16,
    startMinute: 0,
    consultMinutes: 12,
    dailyLimit: 25,
  ),
  Doctor(
    id: 'd3',
    name: 'Dr. Kamrul Hasan',
    specialty: 'Dentist',
    hospital: 'Ibn Sina Hospital, Sylhet',
    rating: 4.5,
    experienceYears: 10,
    fee: 700,
    bio:
        'Dental surgeon experienced in root canal treatment, orthodontics and '
        'cosmetic restoration.',
    availableDays: <int>[7, 1, 3],
    startHour: 10,
    startMinute: 0,
    consultMinutes: 20,
    dailyLimit: 15,
  ),
  Doctor(
    id: 'd4',
    name: 'Dr. Nusrat Jahan',
    specialty: 'Child Specialist',
    hospital: 'North East Medical College Hospital',
    rating: 4.9,
    experienceYears: 9,
    fee: 900,
    bio:
        'Paediatrician specialising in newborn care, childhood nutrition and '
        'routine immunisation.',
    availableDays: <int>[7, 2, 4],
    startHour: 18,
    startMinute: 0,
    consultMinutes: 10,
    dailyLimit: 30,
  ),
  Doctor(
    id: 'd5',
    name: 'Dr. Arif Chowdhury',
    specialty: 'Neurologist',
    hospital: 'Al-Haramain Hospital, Sobhanighat',
    rating: 4.6,
    experienceYears: 15,
    fee: 1200,
    bio:
        'Neurologist treating migraine, epilepsy, stroke rehabilitation and '
        'nerve disorders.',
    availableDays: <int>[1, 4],
    startHour: 19,
    startMinute: 0,
    consultMinutes: 20,
    dailyLimit: 12,
  ),
  Doctor(
    id: 'd6',
    name: 'Dr. Mahmuda Akter',
    specialty: 'Cardiologist',
    hospital: 'Mount Adora Hospital, Akhalia',
    rating: 4.4,
    experienceYears: 6,
    fee: 850,
    bio:
        'Cardiologist with a focus on echocardiography, arrhythmia screening and '
        'lifestyle-based heart care.',
    availableDays: <int>[2, 5, 7],
    startHour: 15,
    startMinute: 30,
    consultMinutes: 15,
    dailyLimit: 18,
  ),
  Doctor(
    id: 'd7',
    name: 'Dr. Rezaul Karim',
    specialty: 'Orthopedic',
    hospital: 'Popular Diagnostic Centre, Sylhet',
    rating: 4.7,
    experienceYears: 14,
    fee: 1000,
    bio:
        'Orthopaedic surgeon handling fractures, joint replacement and sports '
        'injury rehabilitation.',
    availableDays: <int>[3, 6],
    startHour: 17,
    startMinute: 30,
    consultMinutes: 15,
    dailyLimit: 20,
  ),
  Doctor(
    id: 'd8',
    name: 'Dr. Farhana Islam',
    specialty: 'Dermatologist',
    hospital: 'Ibn Sina Hospital, Sylhet',
    rating: 4.3,
    experienceYears: 5,
    fee: 600,
    bio:
        'Dermatologist treating fungal infections, allergic skin conditions and '
        'paediatric skin problems.',
    availableDays: <int>[1, 2, 4],
    startHour: 11,
    startMinute: 0,
    consultMinutes: 10,
    dailyLimit: 25,
  ),
  Doctor(
    id: 'd9',
    name: 'Dr. Tanvir Ahmed',
    specialty: 'Dentist',
    hospital: 'Al-Haramain Hospital, Sobhanighat',
    rating: 4.6,
    experienceYears: 7,
    fee: 750,
    bio:
        'Dental specialist in oral surgery, dental implants and paediatric '
        'dentistry.',
    availableDays: <int>[5, 6, 7],
    startHour: 16,
    startMinute: 0,
    consultMinutes: 20,
    dailyLimit: 14,
  ),
  Doctor(
    id: 'd10',
    name: 'Dr. Shirin Sultana',
    specialty: 'Child Specialist',
    hospital: 'Popular Diagnostic Centre, Sylhet',
    rating: 4.8,
    experienceYears: 11,
    fee: 950,
    bio:
        'Paediatric consultant with special interest in childhood asthma, growth '
        'monitoring and developmental care.',
    availableDays: <int>[3, 5, 7],
    startHour: 18,
    startMinute: 30,
    consultMinutes: 12,
    dailyLimit: 22,
  ),
];
