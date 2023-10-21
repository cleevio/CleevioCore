import Foundation

public struct AppVersion: Comparable, CustomStringConvertible {
    public var major: Int
    public var minor: Int
    public var patch: Int

    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public var description: String {
        "\(major).\(minor).\(patch)"
    }

    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else {
            return lhs.patch < rhs.patch
        }
    }
}

extension AppVersion: Codable {
    public init(from string: String) throws {
        let versionComponents = string.split(separator: ".").compactMap { Int($0) }

        guard versionComponents.count >= 2 else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid version string"))
        }

        major = versionComponents[0]
        minor = versionComponents[1]
        patch = (versionComponents.endIndex-1 > 1) ? versionComponents[2] : 0
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        try self.init(from: versionString)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}


