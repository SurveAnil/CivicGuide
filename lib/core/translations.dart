// ignore_for_file: public_member_api_docs
class Translations {
  static String t(String key, String language) {
    const translations = {
      'English': {
        'country_prompt': 'Great! I will now respond in English. To get started, where will you be voting?',
        'other_error': 'Sorry, CivicGuide is currently only available for United States and Indian elections.',
        'restart_prompt': 'Hello! I am your non-partisan CivicGuide. I can help you understand local election processes. To get started, where will you be voting?',
        'us_zip_prompt': 'Great. Please enter your 5-digit US Zip Code.',
        'in_pin_prompt': 'Namaste. Please enter your 6-digit Indian PIN Code.',
        'invalid_option': 'Please select a valid option from the choices above.',
        'us_zip_success': 'Thank you! US Zip Code saved. What election information do you need today?',
        'us_zip_invalid': 'Please enter a valid 5-digit US Zip Code.',
        'in_pin_success': 'Thank you! Indian PIN Code saved. What election information do you need today?',
        'in_pin_invalid': 'Please enter a valid 6-digit Indian PIN Code.',
      },
      'Hindi': {
        'country_prompt': 'बढ़िया! मैं अब हिंदी में जवाब दूंगा। शुरू करने के लिए, आप कहाँ मतदान करेंगे?',
        'other_error': 'क्षमा करें, CivicGuide वर्तमान में केवल संयुक्त राज्य अमेरिका और भारतीय चुनावों के लिए उपलब्ध है।',
        'restart_prompt': 'नमस्ते! मैं आपका निष्पक्ष CivicGuide हूँ। शुरू करने के लिए, आप कहाँ मतदान करेंगे?',
        'us_zip_prompt': 'बढ़िया। कृपया अपना 5-अंकीय US ज़िप कोड दर्ज करें।',
        'in_pin_prompt': 'नमस्ते। कृपया अपना 6-अंकीय भारतीय पिन कोड दर्ज करें।',
        'invalid_option': 'कृपया ऊपर दिए गए विकल्पों में से एक वैध विकल्प चुनें।',
        'us_zip_success': 'धन्यवाद! US ज़िप कोड सहेजा गया। आज आपको चुनाव की कौन सी जानकारी चाहिए?',
        'us_zip_invalid': 'कृपया एक वैध 5-अंकीय US ज़िप कोड दर्ज करें।',
        'in_pin_success': 'धन्यवाद! भारतीय पिन कोड सहेजा गया। आज आपको चुनाव की कौन सी जानकारी चाहिए?',
        'in_pin_invalid': 'कृपया एक वैध 6-अंकीय भारतीय पिन कोड दर्ज करें।',
      },
      'Marathi': {
        'country_prompt': 'उत्तम! मी आता मराठीत उत्तर देईन. सुरुवात करण्यासाठी, तुम्ही कुठे मतदान करणार आहात?',
        'other_error': 'क्षमस्व, CivicGuide सध्या फक्त युनायटेड स्टेट्स आणि भारतीय निवडणुकांसाठी उपलब्ध आहे.',
        'restart_prompt': 'नमस्कार! मी तुमचा निष्पक्ष CivicGuide आहे. सुरुवात करण्यासाठी, तुम्ही कुठे मतदान करणार आहात?',
        'us_zip_prompt': 'उत्तम. कृपया तुमचा ५-अंकी US झिप कोड प्रविष्ट करा.',
        'in_pin_prompt': 'नमस्ते. कृपया तुमचा ६-अंकी भारतीय पिन कोड प्रविष्ट करा.',
        'invalid_option': 'कृपया वरील पर्यायांमधून योग्य पर्याय निवडा.',
        'us_zip_success': 'धन्यवाद! US झिप कोड जतन केला. आज तुम्हाला कोणती निवडणूक माहिती हवी आहे?',
        'us_zip_invalid': 'कृपया वैध ५-अंकी US झिप कोड प्रविष्ट करा.',
        'in_pin_success': 'धन्यवाद! भारतीय पिन कोड जतन केला. आज तुम्हाला कोणती निवडणूक माहिती हवी आहे?',
        'in_pin_invalid': 'कृपया वैध ६-अंकी भारतीय पिन कोड प्रविष्ट करा.',
      },
      'Spanish': {
        'country_prompt': '¡Genial! Ahora responderé en español. Para comenzar, ¿dónde votará?',
        'other_error': 'Lo sentimos, CivicGuide actualmente solo está disponible para elecciones en Estados Unidos e India.',
        'restart_prompt': '¡Hola! Soy tu CivicGuide imparcial. Para comenzar, ¿dónde votará?',
        'us_zip_prompt': 'Genial. Ingrese su código postal estadounidense de 5 dígitos.',
        'in_pin_prompt': 'Namaste. Ingrese su código PIN indio de 6 dígitos.',
        'invalid_option': 'Seleccione una opción válida de las anteriores.',
        'us_zip_success': '¡Gracias! Código postal guardado. ¿Qué información electoral necesita hoy?',
        'us_zip_invalid': 'Ingrese un código postal estadounidense válido de 5 dígitos.',
        'in_pin_success': '¡Gracias! Código PIN guardado. ¿Qué información electoral necesita hoy?',
        'in_pin_invalid': 'Ingrese un código PIN indio válido de 6 dígitos.',
      }
    };
    final langDict = translations[language] ?? translations['English']!;
    return langDict[key] ?? translations['English']![key]!;
  }

  static List<String> tList(String key, String language) {
    const translations = {
      'English': {
        'country_chips': ["🇺🇸 United States", "🇮🇳 India", "🌍 Other"],
        'us_chips': ["Am I registered?", "Upcoming dates", "Polling locations", "Mail-in voting"],
        'in_chips': ["Check NVSP status", "Form 6 Registration", "Upcoming dates", "Download e-EPIC"],
      },
      'Hindi': {
        'country_chips': ["🇺🇸 अमेरिका", "🇮🇳 भारत", "🌍 अन्य"],
        'us_chips': ["क्या मैं पंजीकृत हूँ?", "आगामी तिथियां", "मतदान केंद्र", "मेल-इन वोटिंग"],
        'in_chips': ["NVSP स्थिति जांचें", "फॉर्म 6 पंजीकरण", "आगामी तिथियां", "ई-ईपीआईसी डाउनलोड करें"],
      },
      'Marathi': {
        'country_chips': ["🇺🇸 अमेरिका", "🇮🇳 भारत", "🌍 इतर"],
        'us_chips': ["मी नोंदणीकृत आहे का?", "आगामी तारखा", "मतदान केंद्रे", "मेल-इन मतदान"],
        'in_chips': ["NVSP स्थिती तपासा", "फॉर्म 6 नोंदणी", "आगामी तारखा", "ई-ईपीआयसी डाउनलोड करा"],
      },
      'Spanish': {
        'country_chips': ["🇺🇸 Estados Unidos", "🇮🇳 India", "🌍 Otro"],
        'us_chips': ["¿Estoy registrado?", "Próximas fechas", "Lugares de votación", "Voto por correo"],
        'in_chips': ["Verificar estado NVSP", "Registro Formulario 6", "Próximas fechas", "Descargar e-EPIC"],
      }
    };
    final langDict = translations[language] ?? translations['English']!;
    return langDict[key] ?? translations['English']![key]!;
  }
}
