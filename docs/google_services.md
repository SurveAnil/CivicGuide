# Google Services Integration Mapping

This document maps each Google Service used in **CivicGuide** to its specific user benefit, product role, and security implementation.

## 🧱 1. Firebase Authentication
- **User Benefit**: Enables cross-device synchronization of voting checklists and registration data while allowing a frictionless "Guest Mode" for privacy-first users.
- **Product Role**: Gatekeeper for personalized features (e.g., ID scanning, cloud backup).
- **Security Rule**: 
  ```text
  allow read, write: if request.auth != null && request.auth.uid == userId;
  ```

## 📊 2. Firebase Analytics
- **User Benefit**: Helps developers identify which languages and election resources are most in-demand to prioritize future content updates.
- **Product Role**: Performance and engagement monitoring (privacy-safe, non-PII).
- **Logged Events**:
    - `select_language`: Track multilingual adoption.
    - `checklist_action`: Measure user progress through the voting journey.
    - `screen_view_custom`: Identify the most useful resource hubs.

## ☁️ 3. Cloud Firestore
- **User Benefit**: Real-time persistence of the user's "Voting Journey" progress and registration details extracted via AI.
- **Product Role**: Main application database for user-specific civic state.
- **Data Model**:
    - `checklistProgress`: Map of completed voting steps.
    - `voterData`: OCR-extracted registration information.
    - `languagePreference`: Persisted UI language.

## 🤖 4. Gemini 2.5 Flash (AI Pipelines)
- **User Benefit**: Provides 24/7 expert guidance on complex, multi-regional election laws in plain English (8th-grade level) and local languages.
- **Product Role**: The core conversational engine and multimodal document analyzer.
- **Pipelines**:
    - **Vision**: Analyzes physical Voter ID cards and election mail.
    - **Civic Engine**: Translates raw Google Civic JSON into actionable summaries.

## 📍 5. Google Civic Information API
- **User Benefit**: Connects US voters directly to their official polling locations, early voting dates, and state election officials based on their ZIP code.
- **Product Role**: Source of truth for US geographic election data.

---
*Generated for the CivicGuide Engineering Audit.*
