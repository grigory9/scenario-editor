//
//  EditorButton.swift
//  BlogScenario
//
//  Created by  userauto on 17.01.2021.
//

import UIKit
import Proton

final class EditorButton: UIView {

	private lazy var button: UIButton = {
		let button = UIButton()
		self.addSubview(button)
		button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
		return button
	}()

	var didTapAction: ((EditorButton) -> Void)

	var isSelected: Bool = false {
		didSet {
			UIView.animate(withDuration: 0.1) { [weak self] in
				self?.backgroundColor = (self?.isSelected == true) ? .systemGray3 : UIColor.clear
			}
		}
	}

	let command: EditorExecCommand

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

	@objc
	func didTap() {
		command.exec()
		didTapAction(self)
	}

	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
			button.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
			button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
			button.widthAnchor.constraint(equalToConstant: 24.0),
			button.heightAnchor.constraint(equalToConstant: 24.0),
		])

		button.backgroundColor = UIColor.clear
		self.layer.cornerRadius = 8.0
	}
}

