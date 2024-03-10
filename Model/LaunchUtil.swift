import Foundation

class LaunchUtil {
    private static let versionKey = "currentVersion"
    private static let buildKey = "currentBuild"
    
    static var launchStatus: LaunchStatus {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let currentBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let savedVersion = UserDefaults.standard.string(forKey: versionKey)
        let savedBuild = UserDefaults.standard.string(forKey: buildKey)
        
        // 初回起動またはバージョン/ビルド番号が変更された場合
        if savedVersion != currentVersion || savedBuild != currentBuild {
            UserDefaults.standard.set(currentVersion, forKey: versionKey)
            UserDefaults.standard.set(currentBuild, forKey: buildKey)
            return .firstLaunch
        } else {
            return .launched
        }
    }

}

enum LaunchStatus {
    case firstLaunch
    case launched
}


