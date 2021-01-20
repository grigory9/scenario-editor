//
//  ToolbarEditorButton.swift
//  BlogScenario
//
//  Created by  userauto on 16.01.2021.
//

import SwiftUI
import Proton

/// TODO: https://github.com/grigory9/scenario-editor/issues/2
/// Refactor toolbar layout of the ToolbarEditorButton
final class ToolbarEditorButton: UIView {

	private lazy var button: UIButton = {
		let button = UIButton()
		self.addSubview(button)
		button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
		return button
	}()

	var didTapAction: ((ToolbarEditorButton) -> Void)

	var isSelected: Bool = false {
		didSet {
			UIView.animate(withDuration: 0.1) { [weak self] in
				self?.button.backgroundColor = (self?.isSelected == true) ? UIColor(white: 0.4, alpha: 0.4) : UIColor.clear
			}
		}
	}

	let command: EditorExecCommand?

	init(command: EditorExecCommand?, icon: UIImage, didTapAction: @escaping ((ToolbarEditorButton) -> Void)) {
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
		command?.exec()
		didTapAction(self)
	}

	private func configure() {
		frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.frame = CGRect(x: 7, y: 5, width: 34, height: 34)

		button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

		button.backgroundColor = UIColor.clear
		button.layer.cornerRadius = 8.0
	}
}
