import '../models/diagnostic_center.dart';
import '../models/price_item.dart';

/// Static demo diagnostic centres with their test and pharmacy price lists.
const List<DiagnosticCenter> kDemoCenters = <DiagnosticCenter>[
  DiagnosticCenter(
    id: 'c1',
    name: 'Popular Diagnostic Centre',
    location: 'Subid Bazar, Sylhet',
    rating: 4.6,
    openingHours: '8:00 AM – 10:00 PM',
    tests: <PriceItem>[
      PriceItem(name: 'ECG', price: 500, unit: 'per test'),
      PriceItem(name: 'X-Ray (Chest P/A)', price: 700, unit: 'per plate'),
      PriceItem(name: 'CBC (Complete Blood Count)', price: 400, unit: 'per test'),
      PriceItem(name: 'Blood Sugar (Fasting)', price: 250, unit: 'per test'),
      PriceItem(name: 'Ultrasonogram (Whole Abdomen)', price: 1200, unit: 'per scan'),
      PriceItem(name: 'Lipid Profile', price: 1100, unit: 'per test'),
      PriceItem(name: 'Serum Creatinine', price: 450, unit: 'per test'),
      PriceItem(name: 'Urine R/E', price: 300, unit: 'per test'),
    ],
    medicines: <PriceItem>[
      PriceItem(name: 'Napa 500mg', price: 12, unit: 'per strip of 10'),
      PriceItem(name: 'Seclo 20mg', price: 90, unit: 'per strip of 10'),
      PriceItem(name: 'Monas 10mg', price: 200, unit: 'per strip of 10'),
      PriceItem(name: 'Fexo 120mg', price: 110, unit: 'per strip of 10'),
      PriceItem(name: 'Maxpro 20mg', price: 70, unit: 'per strip of 10'),
      PriceItem(name: 'Ceevit', price: 45, unit: 'per strip of 10'),
    ],
  ),
  DiagnosticCenter(
    id: 'c2',
    name: 'Ibn Sina Diagnostic Centre',
    location: 'Zindabazar, Sylhet',
    rating: 4.4,
    openingHours: '7:30 AM – 11:00 PM',
    tests: <PriceItem>[
      PriceItem(name: 'ECG', price: 450, unit: 'per test'),
      PriceItem(name: 'X-Ray (Chest P/A)', price: 650, unit: 'per plate'),
      PriceItem(name: 'CT Scan (Brain)', price: 4500, unit: 'per scan'),
      PriceItem(name: 'CBC (Complete Blood Count)', price: 380, unit: 'per test'),
      PriceItem(name: 'Thyroid Profile (TSH)', price: 900, unit: 'per test'),
      PriceItem(name: 'Blood Grouping', price: 200, unit: 'per test'),
      PriceItem(name: 'Ultrasonogram (Pregnancy Profile)', price: 1300, unit: 'per scan'),
    ],
    medicines: <PriceItem>[
      PriceItem(name: 'Ace 500mg', price: 10, unit: 'per strip of 10'),
      PriceItem(name: 'Losectil 20mg', price: 85, unit: 'per strip of 10'),
      PriceItem(name: 'Alatrol 10mg', price: 30, unit: 'per strip of 10'),
      PriceItem(name: 'Amodis 400mg', price: 140, unit: 'per strip of 10'),
      PriceItem(name: 'Sergel 20mg', price: 95, unit: 'per strip of 10'),
      PriceItem(name: 'Filmet 400mg', price: 60, unit: 'per strip of 10'),
    ],
  ),
  DiagnosticCenter(
    id: 'c3',
    name: 'Medinova Medical Services',
    location: 'Chouhatta, Sylhet',
    rating: 4.5,
    openingHours: '8:00 AM – 9:00 PM',
    tests: <PriceItem>[
      PriceItem(name: 'MRI (Lumbar Spine)', price: 6500, unit: 'per scan'),
      PriceItem(name: 'ECG', price: 500, unit: 'per test'),
      PriceItem(name: 'Echocardiogram', price: 2200, unit: 'per test'),
      PriceItem(name: 'HbA1c', price: 1000, unit: 'per test'),
      PriceItem(name: 'Liver Function Test', price: 1400, unit: 'per panel'),
      PriceItem(name: 'Vitamin D (25-OH)', price: 2500, unit: 'per test'),
      PriceItem(name: 'X-Ray (Knee Joint)', price: 600, unit: 'per plate'),
    ],
    medicines: <PriceItem>[
      PriceItem(name: 'Napa Extend 665mg', price: 25, unit: 'per strip of 10'),
      PriceItem(name: 'Pantonix 20mg', price: 100, unit: 'per strip of 10'),
      PriceItem(name: 'Deslor 5mg', price: 120, unit: 'per strip of 10'),
      PriceItem(name: 'Bexitrol F', price: 480, unit: 'per inhaler'),
      PriceItem(name: 'Calbo-D', price: 160, unit: 'per strip of 10'),
      PriceItem(name: 'Zimax 500mg', price: 220, unit: 'per strip of 3'),
    ],
  ),
];
