import Foundation

public enum AppLocalization {
    public static var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    public static var localeIdentifier: String {
        Locale.current.region?.identifier == "RU" ? "ru_RU" : "en_US"
    }

    public static func string(_ key: String) -> String {
        NSLocalizedString(key, bundle: localizationBundle, value: key, comment: "")
    }

    public static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: string(key), locale: locale, arguments: arguments)
    }

    private static var localizationBundle: Bundle {
        let languageCode = localeIdentifier.hasPrefix("ru") ? "ru" : "en"
        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .module
        }
        return bundle
    }
}
