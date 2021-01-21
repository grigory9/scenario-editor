//
//  EditorButton.swift
//  BlogScenario
//
//  Created by  userauto on 17.01.2021.
//

import UIKit
import Proton

final class EditorButton: UIView {

	struct Metrics {
		static let width: CGFloat = 24.0
		static let height: CGFloat = 24.0
		static let buttonOffset: CGFloat = 8.0
	}

	var didTapAction: ((EditorButton) -> Void)

	var isSelected: Bool = false {
		didSet {
			UIView.animate(withDuration: 0.1) { [weak self] in
				self?.backgroundColor = (self?.isSelected == true) ? .systemGray3 : UIColor.clear
			}
		}
	}

	let command: EditorExecCommand

	private lazy var button: UIButton = {
		let button = UIButton()
		self.addSubview(button)
		button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
		return button
	}()

	init(command: EditorExecCommand, icon: UIImage, didTapAction: @escaping ((EditorButton) -> Void)) {
		self.didTapAction = didTapAction
		self.command = command
		super.init(frame: .null)
		self.configure()
		button.setImage(icon, for: .normal)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private
private extension EditorButton {
	@objc
	func didTap() {
		command.exec()
		didTapAction(self)
	}

	func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.buttonOffset),
			button.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrics.buttonOffset),
			button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.buttonOffset),
			button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metrics.buttonOffset),
			button.widthAnchor.constraint(equalToConstant: Metrics.width),
			button.heightAnchor.constraint(equalToConstant: Metrics.height),
		])

		button.backgroundColor = UIColor.clear
		self.layer.cornerRadius = 8.0
	}
}
