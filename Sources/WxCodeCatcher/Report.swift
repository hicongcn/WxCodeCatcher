import Foundation

/// 把抓到的 code 上报出去。默认开一个本地 HTTP 服务(8766)记录,
/// 同时可用 UserDefaults 存最近 20 条历史。
enum Report {

    static func post(code: String, state: String, raw: String) {
        store(code: code, state: state, raw: raw)
        // 可选: 改成本机/局域网 IP 或你自己的接收端
        // send(code: code, state: state, raw: raw)
    }

    private static func store(code: String, state: String, raw: String) {
        let key = "wx_code_history"
        var arr = UserDefaults.standard.array(forKey: key) as? [[String: String]] ?? []
        arr.insert([
            "time": ISO8601DateFormatter().string(from: Date()),
            "code": code,
            "state": state,
            "raw": raw
        ], at: 0)
        if arr.count > 20 { arr = Array(arr.prefix(20)) }
        UserDefaults.standard.set(arr, forKey: key)
    }

    /// 需要时打开: 上报到自建接收端
    private static func send(code: String, state: String, raw: String) {
        guard let url = URL(string: "http://192.168.1.100:8766/callback") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["code": code, "state": state, "raw": raw]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: req).resume()
    }
}
