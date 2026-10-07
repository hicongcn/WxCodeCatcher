import UIKit

class ViewController: UIViewController {

    private let titleLabel = UILabel()
    private let urlLabel = UITextView()
    private let codeLabel = UILabel()
    private let copyBtn = UIButton(type: .system)
    private let clearBtn = UIButton(type: .system)

    private var lastCode: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "微信授权回调捕获器"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        codeLabel.text = "code: (等待回调...)"
        codeLabel.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        codeLabel.numberOfLines = 0
        codeLabel.textColor = .systemBlue
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeLabel)

        urlLabel.isEditable = false
        urlLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        urlLabel.layer.borderColor = UIColor.separator.cgColor
        urlLabel.layer.borderWidth = 1
        urlLabel.layer.cornerRadius = 8
        urlLabel.text = "等待 wx3fea7a3c94a23944:// 或 Universal Link 回调..."
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urlLabel)

        copyBtn.setTitle("复制 code", for: .normal)
        copyBtn.addTarget(self, action: #selector(copyCode), for: .touchUpInside)
        copyBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(copyBtn)

        clearBtn.setTitle("清空", for: .normal)
        clearBtn.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearBtn)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            codeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            codeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            urlLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 16),
            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlLabel.heightAnchor.constraint(equalToConstant: 220),

            copyBtn.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 16),
            copyBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),

            clearBtn.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 16),
            clearBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    func show(url: String, code: String?, state: String?) {
        urlLabel.text = url
        if let c = code, !c.isEmpty {
            lastCode = c
            codeLabel.text = "code: \(c)\n\nstate: \(state ?? "-")\n(已复制到剪贴板)"
            UIPasteboard.general.string = c
        } else {
            codeLabel.text = "回调到达但未找到 code 参数\nURL 已显示在下方"
        }
    }

    @objc private func copyCode() {
        guard !lastCode.isEmpty else { return }
        UIPasteboard.general.string = lastCode
        let alert = UIAlertController(title: "已复制", message: lastCode, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default))
        present(alert, animated: true)
    }

    @objc private func clearAll() {
        lastCode = ""
        codeLabel.text = "code: (等待回调...)"
        urlLabel.text = "已清空, 等待新回调..."
    }
}
