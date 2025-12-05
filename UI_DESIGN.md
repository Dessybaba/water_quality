# Water Quality App - UI Design Guide

## Design Philosophy

The app features a modern, clean, and water-themed design with excellent user experience principles.

## Color Palette

### Primary Colors
- **Primary Blue**: `#0A84FF` - Main brand color, used for buttons, app bars, and primary actions
- **Primary Blue Dark**: `#0051D5` - Darker shade for hover states
- **Primary Blue Light**: `#5AC8FA` - Lighter shade for accents
- **Accent Teal**: `#00C7BE` - Used for secondary actions (GPS button)

### Background Colors
- **Background Light**: `#F5F9FC` - Main app background
- **Surface White**: `#FFFFFF` - Cards and surfaces

### Text Colors
- **Text Dark**: `#1D1D1F` - Primary text
- **Text Light**: `#86868B` - Secondary text, hints

### Status Colors
- **Success Green**: `#34C759` - Success messages
- **Error Red**: `#FF3B30` - Error messages
- **Warning Orange**: `#FF9500` - Warning messages

### WQI Classification Colors
- **Excellent** (WQI ≥ 90): `#34C759` (Green)
- **Good** (WQI ≥ 70): `#5AC8FA` (Light Blue)
- **Poor** (WQI ≥ 50): `#FF9500` (Orange)
- **Very Poor** (WQI < 50): `#FF3B30` (Red)

## Typography

**Font Family**: Inter (Google Fonts)

### Text Styles
- **Display Large**: 32px, Bold - Main titles
- **Display Medium**: 28px, Bold - Section titles
- **Display Small**: 24px, Semi-bold - Card titles
- **Headline**: 20px, Semi-bold - App bar titles
- **Body Large**: 16px, Regular - Body text
- **Body Medium**: 14px, Regular - Secondary text
- **Body Small**: 12px, Regular - Captions, hints

## Components

### 1. Home Screen

**Layout:**
- Curved header with gradient blue background
- Water drop icon with record count
- Scrollable list of record cards
- Floating action button (FAB) for new assessment

**Empty State:**
- Large water drop icon
- Clear message "No Records Yet"
- Call-to-action button

**Record Cards:**
- White background with subtle shadow
- Rounded corners (16px radius)
- Location name as title
- Date and time
- WQI classification badge (color-coded)
- Key metrics (WQI, pH)
- Location icon if GPS tagged

### 2. Data Form Screen

**Layout:**
- Clean form layout with sections
- Grouped parameters by category:
  - Location Information
  - Basic Parameters
  - Oxygen Parameters
  - Other Parameters
  - Notes

**Form Fields:**
- Material Design 3 text fields
- Rounded borders (12px radius)
- Clear labels with units
- Optional fields clearly marked
- GPS button with loading state
- Coordinates display box when available

**Buttons:**
- Primary button: Full width, blue background
- GPS button: Teal accent color
- Loading indicators for async operations

### 3. Record Detail Screen

**Layout:**
- Large WQI display card with color-coded background
- Collapsible sections:
  - Location Information
  - Water Quality Parameters (table format)
  - Notes

**WQI Card:**
- Full-width card with rounded corners
- Large WQI number (56px)
- Classification text below
- Background color matches WQI status

**Parameter Display:**
- Clean table format
- Parameter name on left
- Value and unit on right
- Easy to scan

**Actions:**
- Edit button in app bar
- Menu with PDF and Delete options
- Generate PDF button at bottom

### 4. Components

#### Water Quality Card
- Hover/press effects
- Color-coded classification badge
- Responsive layout

#### Input Fields
- Consistent styling
- Error states
- Validation feedback
- Unit labels

#### Buttons
- Rounded corners (12px)
- Proper padding
- Loading states
- Disabled states

## Design Patterns

### Navigation
- Material Design 3 navigation
- Clear hierarchy
- Back button always visible
- Contextual actions in app bar

### Feedback
- Snack bars for actions (save, delete, etc.)
- Loading indicators for async operations
- Error messages in red
- Success messages in green

### Spacing
- Consistent 16px padding
- 12px spacing between elements
- 24px section spacing

### Shadows & Elevation
- Cards: 0 elevation (flat design)
- Buttons: 0 elevation
- Subtle borders instead of shadows

## Responsive Design

- Designed for mobile (portrait orientation)
- Minimum touch target: 48x48px
- Proper text scaling
- Scrollable content where needed

## Accessibility

- Clear color contrast ratios
- Readable font sizes
- Touch-friendly targets
- Semantic labels

## User Experience Flow

1. **Home Screen** → View all records
2. **Tap FAB** → Create new assessment
3. **Fill Form** → Enter data, get GPS location
4. **Calculate & Save** → Auto-calculate WQI, save to storage
5. **View Record** → See details, generate PDF, edit or delete

## Material Design 3

The app uses Material Design 3 principles:
- Dynamic color system
- Rounded corners
- Modern typography
- Clean spacing
- Clear hierarchy

---

**Design System Version**: 1.0.0
**Last Updated**: 2024

