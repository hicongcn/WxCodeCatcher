import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let w = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        w.rootViewController = vc
        w.makeKeyAndVisible()
        self.window = w
        return true
    }

    // MARK: - 微信回调入口 (scheme 方式)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handleIncoming(url.absoluteString)
        return true
    }

    // MARK: - Universal Link 回调 (如果微信走 UL)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            handleIncoming(url.absoluteString)
            return true
        }
        return false
    }

    private func handleIncoming(_ urlString: String) {
        NSLog("[WxCodeCatcher] CALLBACK URL: \(urlString)")
        let code = extractParam("code", from: urlString)
        let state = extractParam("state", from: urlString)

        // 展示
        DispatchQueue.main.async {
            (self.window?.rootViewController as? ViewController)?.show(url: urlString, code: code, state: state)
        }

        // 上报到本地/远程 (可选): 优先上报, 失败也无所谓
        if let c = code {
            Report.post(code: c, state: state ?? "", raw: urlString)
        }
    }

    private func extractParam(_ key: String, from url: String) -> String? {
        guard let comp = URLComponents(string: url) else { return nil }
        return comp.queryItems?.first(where: { $0.name == key })?.value
    }
}
