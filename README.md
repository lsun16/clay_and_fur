# Clay and Fur - Pottery Tracker

A native iOS app for tracking pottery pieces from creation to completion.

## Overview

Clay and Fur helps potters track their pieces through the entire lifecycle:
- **Piece lifecycle tracking**: throwing → trimming → drying → bisque → glazing → firing
- **Drag & drop workflow**: Move pieces between stages with simple gestures
- **Custom material libraries**: Clay bodies, glazes, and firing methods
- **Smart selectors**: Dropdown menus for easy material selection
- **Photo attachments**: Document your work at any stage
- **iCloud sync**: Seamless multi-device usage with CloudKit

## Features

- 📱 **iOS-native** with SwiftUI interface
- 🔄 **Offline-capable** with CloudKit sync
- 🎯 **Drag & drop** stage progression
- 📋 **Custom material lists** (clay bodies, glazes, firing methods)
- 📸 **Photo tracking** at every stage
- 🎨 **Glaze management** with recipes and cone ratings
- 🔥 **Firing logs** with piece tracking
- 🏠 **Kanban dashboard** showing pieces by stage
- 🔍 **Search & filter** by name, clay body, stage, glaze
- 🔔 **Local notifications** for firing reminders
- 🔒 **Privacy-first** - all data stays in your iCloud

## Tech Stack

- **Language**: Swift 5+
- **UI**: SwiftUI + NavigationStack
- **Data**: SwiftData with CloudKit sync
- **Storage**: CloudKit private database
- **Media**: Photos framework, CKAsset storage
- **Notifications**: Local notifications only

## Requirements

- iOS 17.0+ (SwiftData requirement)
- Xcode 15.0+
- Swift 5.9+
- iCloud account for sync

## Stage Colors

- **Thrown**: Blue
- **Trimmed**: Teal  
- **Leather-hard**: Orange
- **Bone-dry**: Yellow
- **Bisque**: Red
- **Glazed**: Purple
- **Glaze-fired**: Green

## Project Structure

```
ClayAndFur/
├── ClayAndFur/
│   ├── App/
│   │   ├── ClayAndFurApp.swift
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── Piece.swift
│   │   ├── StageEvent.swift
│   │   ├── Glaze.swift
│   │   ├── Firing.swift
│   │   ├── Media.swift
│   │   └── ClayBody.swift
│   ├── Views/
│   │   ├── Dashboard/
│   │   │   └── DashboardView.swift
│   │   ├── Pieces/
│   │   │   ├── PiecesListView.swift
│   │   │   ├── PieceDetailView.swift
│   │   │   ├── AddPieceView.swift
│   │   │   └── AddStageEventView.swift
│   │   ├── Glazes/
│   │   │   └── GlazesListView.swift
│   │   ├── Firings/
│   │   │   └── FiringsListView.swift
│   │   └── Settings/
│   │       └── SettingsView.swift
│   ├── Services/
│   │   └── DataSeeder.swift
│   ├── Utilities/
│   │   └── Stage.swift
│   ├── Assets.xcassets/
│   └── Preview Content/
├── ClayAndFurTests/
└── ClayAndFurUITests/
```

## Current Features (Phase 1 Complete ✅)

### **Core Functionality**
- ✅ **SwiftData Models** with CloudKit sync
- ✅ **Kanban Dashboard** with horizontal scrolling
- ✅ **Drag & Drop** between stage columns
- ✅ **Stage Progression** with automatic timestamps
- ✅ **Piece Management** (create, edit, view, delete)
- ✅ **Custom Material Lists** (clay bodies, glazes, firing methods)
- ✅ **Smart Dropdowns** in forms
- ✅ **Default Data Seeding** on first launch

### **Stage Workflow**
- ✅ **7-Stage Pipeline**: Thrown → Trimmed → Leather Hard → Bone Dry → Bisque → Glazed → Glaze Fired
- ✅ **Color-coded Columns** for visual organization
- ✅ **Timeline View** showing piece history
- ✅ **Stage Notes** for detailed tracking

### **Material Management**
- ✅ **Clay Bodies**: Stoneware, Porcelain, Earthenware, B-Mix, Raku Clay
- ✅ **Glazes**: Clear, Celadon, Tenmoku, White Satin, Blue Green, Copper Red, Ash Glaze
- ✅ **Firing Methods**: Electric Bisque, Gas Reduction, Raku, Wood Firing, Soda Firing

## Development Phases

### Phase 1 - Foundations ✅
- [x] Project setup with SwiftData + CloudKit
- [x] Core data models and relationships
- [x] Basic CRUD operations
- [x] Dashboard with Kanban layout
- [x] Drag & drop functionality
- [x] Custom material lists
- [x] Smart form selectors

### Phase 2 - Media & Search (Planned)
- [ ] Photo capture and gallery
- [ ] Advanced search and filtering
- [ ] Export functionality

### Phase 3 - Advanced Features (Planned)  
- [ ] Glaze recipe management
- [ ] Firing schedule integration
- [ ] Notifications for firing reminders
- [ ] Batch operations

### Phase 4 - Polish (Planned)
- [ ] Accessibility improvements
- [ ] Performance optimization
- [ ] Advanced UI animations

### Phase 5 - Launch (Planned)
- [ ] TestFlight beta testing
- [ ] App Store submission

## Getting Started

1. Clone the repository
2. Open `ClayAndFur.xcodeproj` in Xcode
3. Ensure you're signed in to iCloud in Xcode
4. Build and run the project
5. The app will automatically seed default materials on first launch

## Usage

### **Creating Pieces**
1. Tap the **+** button on Dashboard or Pieces tab
2. Enter piece name and select materials from dropdowns
3. Piece automatically starts in "Thrown" stage

### **Moving Between Stages**
- **Drag & Drop**: Drag piece cards between stage columns
- **Manual**: Tap piece → "Add Stage" → Select new stage

### **Material Management**
- Materials are pre-populated with pottery standards
- Use "Add New..." in dropdowns to expand lists
- All materials sync across devices via iCloud

## Privacy

Clay and Fur is designed with privacy in mind:
- No external servers or analytics
- All data stored in your personal iCloud account
- Photos stored securely in CloudKit
- No data sharing with third parties

## License

MIT License - see LICENSE file for details
