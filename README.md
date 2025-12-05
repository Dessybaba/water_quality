# Water Quality Assessment Mobile App

A comprehensive Flutter mobile application for water quality assessment with automatic Water Quality Index (WQI) calculation, PDF report generation, GPS tagging, and local data storage.

## Features

- ✅ **Field Data Form** - Easy-to-use form for entering water quality parameters:
  - pH
  - Electrical Conductivity (EC)
  - Total Dissolved Solids (TDS)
  - Biological Oxygen Demand (BOD)
  - Chemical Oxygen Demand (COD)
  - Dissolved Oxygen (DO)
  - Turbidity
  - Total Coliform
  - Fecal Coliform
  - Nitrate (NO₃)
  - Phosphate (PO₄)

- ✅ **Automatic WQI Calculation** - Weighted arithmetic method calculates Water Quality Index automatically

- ✅ **Water Quality Classification**:
  - Excellent (WQI ≥ 90)
  - Good (WQI ≥ 70)
  - Poor (WQI ≥ 50)
  - Very Poor (WQI < 50)

- ✅ **GPS Tagging** - Automatically capture and tag sampling locations with GPS coordinates

- ✅ **PDF Report Generation** - Generate professional PDF reports with all data, WQI, and location information

- ✅ **Local Storage** - Save all records locally using Hive database

- ✅ **Beautiful Modern UI** - Clean, intuitive interface with water-themed color palette

- ✅ **History Management** - View, edit, and delete all your water quality assessments

## Screenshots

The app features a beautiful, modern UI with:
- Card-based design for easy record browsing
- Color-coded WQI indicators
- Smooth animations and transitions
- Material Design 3 components

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd water_quality_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android

The app requires location permissions. These are already configured in `android/app/src/main/AndroidManifest.xml`.

For Android 11+, make sure to handle background location permissions appropriately.

#### iOS

Location permissions are configured in `ios/Runner/Info.plist`. 

**Important**: For iOS, you need to add location permissions in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to Signing & Capabilities
4. Add "Background Modes" capability
5. Enable "Location updates" if needed

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── water_quality_record.dart      # Data model
│   └── water_quality_record_adapter.dart  # Hive adapter
├── screens/
│   ├── home_screen.dart               # Main screen with record list
│   ├── data_form_screen.dart          # Form for entering data
│   └── record_detail_screen.dart      # Detailed view of a record
├── services/
│   ├── storage_service.dart           # Hive storage service
│   ├── wqi_calculator.dart            # WQI calculation logic
│   ├── location_service.dart          # GPS/location services
│   └── pdf_service.dart               # PDF generation service
├── widgets/
│   └── water_quality_card.dart        # Reusable record card widget
└── theme/
    └── app_theme.dart                 # App theme and colors
```

## Usage

### Creating a New Assessment

1. Tap the **"New Assessment"** button on the home screen
2. Enter the location name (required)
3. Optionally tap **"Get GPS Location"** to capture coordinates automatically
4. Enter water quality parameters (all optional, enter what you have)
5. Add any additional notes
6. Tap **"Calculate & Save"** to automatically calculate WQI and save the record

### Viewing Records

- All saved records appear on the home screen
- Tap any record to view detailed information
- Records are sorted by date (newest first)

### Generating PDF Reports

1. Open a record detail view
2. Tap the menu icon (three dots) in the top right
3. Select **"Generate PDF"**
4. The PDF will open for sharing or printing

### Editing/Deleting Records

- **Edit**: Open a record and tap the edit icon, or use the menu
- **Delete**: Open a record, tap the menu, and select "Delete"

## WQI Calculation Method

The app uses the **Weighted Arithmetic Water Quality Index** method:

- Each parameter has a specific weight based on its importance
- Quality sub-indices (Qi) are calculated for each parameter
- Final WQI = Σ(Qi × Wi) where Wi is the weight of parameter i
- WQI ranges from 0-100

### Parameter Weights

- Dissolved Oxygen: 0.17
- Total Coliform: 0.12
- pH: 0.11
- BOD: 0.11
- Turbidity: 0.09
- TDS: 0.08
- Electrical Conductivity: 0.07
- COD: 0.10
- Fecal Coliform: 0.10
- Nitrate: 0.03
- Phosphate: 0.02

## Technologies Used

- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **Hive** - Fast, lightweight local database
- **Provider** - State management
- **Geolocator** - Location services
- **PDF** - PDF generation
- **Printing** - PDF sharing/printing
- **Google Fonts** - Typography

## Future Enhancements

Potential features for future versions:
- Cloud sync with Firebase
- Data visualization and charts
- Export to CSV/Excel
- Multiple WQI calculation methods
- Offline maps integration
- Batch import/export
- User authentication
- Data sharing between devices

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or suggestions, please open an issue on the repository.

---

**Built with ❤️ using Flutter**
