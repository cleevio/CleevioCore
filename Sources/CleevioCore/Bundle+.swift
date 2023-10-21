import Foundation

extension Bundle {
    public var appName: String? {
        object(forInfoDictionaryKey: "CFBundleExecutable") as? String
    }

    public var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    public var targetName: String? {
        infoDictionary?["CFBundleName"] as? String
    }
}

