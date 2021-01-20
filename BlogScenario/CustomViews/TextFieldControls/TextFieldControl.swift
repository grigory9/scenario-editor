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
			self.label.text ?? ""
		}
		set {
			self.label.text = newValue
		}
	}

	struct Metrics {
		static let insets: CGFloat = 8.0
		static let height: CGFloat = 24.0
		static let width: CGFloat = 24.0
	}

	private let label = UILabel()

	init() {
		super.init(frame: .null)

		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure() {
		addSubview(label)
		translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(
			[
				label.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrics.insets),
				label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.insets),
				label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metrics.insets),
				label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.insets),
				label.widthAnchor.constraint(equalToConstant: Metrics.width),
				label.heightAnchor.constraint(equalToConstant: Metrics.height),
			]
		)
	}
}
