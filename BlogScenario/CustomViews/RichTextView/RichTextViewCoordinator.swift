//
//  RichTextViewCoordinator.swift
//  BlogScenario
//
//  Created by  userauto on 19.01.2021.
//

import UIKit
import Proton

final class RichTextViewCoordinator {
	var listFormattingProvider: EditorListFormattingProvider? = nil
	let textDidChange: (EditorView) -> Void
	var toolbarButtons: [ToolbarEditorButton] = []
	var fontButtons: [EditorButton] = []
	var currentButtonLayout: UIView? = nil
	var keyboardFrame: CGRect? = nil

	let view: EditorView

	init(view: EditorView, textDidChange: @escaping (EditorView) -> Void) {
		self.textDidChange = textDidChange
		self.view = view
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}

// MARK: - RichTextView.Coordinator handle toolbar button taps
extension RichTextViewCoordinator {
	func didTapEditFont(_ button: ToolbarEditorButton) {
		self.showButtonsLayout(toolbarButton: button, with: self.makeEditFontButtons)
	}

	func didTapTextResize(_ button: ToolbarEditorButton) {
		self.showButtonsLayout(toolbarButton: button, with: self.makeTextResizeButtons)
	}
}

// MARK: - EditorViewDelegate
extension RichTextViewCoordinator: EditorViewDelegate {
	func editor(_ editor: EditorView, didChangeTextAt range: NSRange) {
		textDidChange(editor)
	}

	func editor(_ editor: EditorView, shouldHandle key: EditorKey, at range: NSRange, handled: inout Bool) {
		textDidChange(editor)
	}

	func editor(_ editor: EditorView, didReceiveKey key: EditorKey, at range: NSRange) {
		textDidChange(editor)
	}

	func editor(_ editor: EditorView, didExecuteProcessors processors: [TextProcessing], at range: NSRange) {
		textDidChange(editor)
	}

	func editor(_ editor: EditorView, didChangeSize currentSize: CGSize, previousSize: CGSize) {
		textDidChange(editor)
	}

	func editor(_ editor: EditorView, didChangeSelectionAt range: NSRange, attributes: [NSAttributedString.Key : Any], contentType: EditorContent.Name) {
		fontButtons.forEach {
			switch $0.command {
			case .bold:
				$0.isSelected = (attributes[.font] as? UIFont)?.isBold == true
			case .italics:
				$0.isSelected = (attributes[.font] as? UIFont)?.isItalics == true
			case .strikeThrough:
				$0.isSelected = attributes[.strikethroughStyle] != nil
			case .underscore:
				$0.isSelected = attributes[.underlineStyle] != nil
			case .list(_):
				break
			case .upscale:
				break
			case .downscale:
				break
			}
		}
	}
}

// MARK: - Private RichTextView.Coordinator
private extension RichTextViewCoordinator {
	@objc
	func keyboardWillShow(_ notification : Notification?) -> Void {
		if let info = notification?.userInfo {
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			//  Getting UIKeyboardSize.
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				let screenSize = UIScreen.main.bounds
				//Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
				let intersectRect = kbFrame.intersection(screenSize)
				if intersectRect.isNull {
					keyboardFrame = CGRect(x: 0, y: screenSize.maxY, width: screenSize.size.width, height: 0)
				} else {
					keyboardFrame = intersectRect
				}
			}
		}
	}

	@objc
	func keyboardWillHide(_ notification : Notification?) -> Void {
		currentButtonLayout?.removeFromSuperview()
	}

	func showButtonsLayout(toolbarButton: ToolbarEditorButton, with makeButtons: (() -> [EditorButton])) {
		resetButtonsLayout()

		toolbarButtons.forEach {
			if toolbarButton.hashValue != $0.hashValue {
				$0.isSelected = false
			}
		}

		guard toolbarButton.isSelected else {
			return
		}

		guard let keyboardWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
			assertionFailure("Cannot find keyboard window")
			return
		}

		guard let keyboardFrame = self.keyboardFrame else {
			assertionFailure("Keyboard frame should not be nil")
			return
		}

		let layoutButtons = makeButtons()
		let buttonLayout = ButtonsLayout(buttons: layoutButtons)
		fontButtons = layoutButtons
		let visibleViewController = keyboardWindow.visibleViewController()
		visibleViewController?.view.addSubview(buttonLayout)
		buttonLayout.setKeyboard(frame: keyboardFrame)
		currentButtonLayout = buttonLayout
	}

	func resetButtonsLayout() {
		currentButtonLayout?.removeFromSuperview()
		currentButtonLayout = nil
	}
}

// MARK: - Private RichTextView.Coordinator make methods
private extension RichTextViewCoordinator {
	func makeEditFontButtons() -> [EditorButton] {
		[
			ToolbarEditorButtonFactory.makeItalicsButton(),
			ToolbarEditorButtonFactory.makeBoldButton(),
			ToolbarEditorButtonFactory.makeUnderscoreButton(),
			ToolbarEditorButtonFactory.makeStrikeThroughButton(),
		]
	}

	func makeTextResizeButtons() -> [EditorButton] {
		let fontSizeLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 32.0, height: 32.0)))
		return [
			ToolbarEditorButtonFactory.makeDownscaleButton(),
			ToolbarEditorButtonFactory.makeUpscaleButton(),
		]
	}
}
