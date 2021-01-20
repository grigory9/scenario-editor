//
//  TextFieldControl.swift
//  BlogScenario
//
//  Created by  userauto on 20.01.2021.
//

import UIKit

final class TextFieldControl: UIView {
	var text: String {
		get {
			self.textField.text ?? ""
		}
		set {
			self.textField.text = newValue
		}
	}

	struct Metrics {
		static let insets: CGFloat = 8.0
		static let size: CGFloat = 24.0
	}

	private let textField = UITextField()
	private let textDidChange: ((String) -> ())

	init(textDidChange: @escaping ((String) -> ())) {
		self.textDidChange = textDidChange
		super.init(frame: .null)

		self.configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrics.insets),
			textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.insets),
			textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Metrics.insets),
			textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metrics.insets),
			textField.widthAnchor.constraint(equalToConstant: Metrics.size),
			textField.heightAnchor.constraint(equalToConstant: Metrics.size),
		])
	}
}

// MARK: - UITextViewDelegate
extension TextFieldControl: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		textDidChange(textView.text)
	}
}
