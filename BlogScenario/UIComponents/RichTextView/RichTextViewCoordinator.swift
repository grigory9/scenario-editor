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
	var fontSizeLabel: TextFieldControl? = nil
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

// MARK: - RichTextViewCoordinator handle toolbar button taps
extension RichTextViewCoordinator {
	func didTapEditFont(_ button: ToolbarEditorButton) {
		showControllsLayout(toolbarButton: button, with: makeEditFontButtons)
	}

	func didTapTextResize(_ button: ToolbarEditorButton) {
		showControllsLayout(toolbarButton: button, with: makeTextResizeButtons, other: [makeFontLabel()])
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
		updateButtonsState(attributes: attributes)
	}
}

// MARK: - Private RichTextViewCoordinator
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
		fontSizeLabel = nil
	}

	func showControllsLayout(toolbarButton: ToolbarEditorButton, with makeButtons: (() -> [EditorButton]), other controlls: [UIView] = []) {
		resetControllsLayout()

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

		fontButtons = makeButtons()

		var viewsToAdd = fontButtons.map { $0 as UIView }
		viewsToAdd.append(contentsOf: controlls)

		let controlsLayout = ControlsLayout(controls: viewsToAdd)
		let visibleViewController = keyboardWindow.visibleViewController()
		visibleViewController?.view.addSubview(controlsLayout)
		controlsLayout.setKeyboard(frame: keyboardFrame)
		currentButtonLayout = controlsLayout

		view.attributedText.enumerateAttributes(in: view.selectedRange, options: .longestEffectiveRangeNotRequired) { (attributes, range, _) in
			if range == view.selectedRange {
				updateButtonsState(attributes: attributes)
			}
		}
	}

	func resetControllsLayout() {
		currentButtonLayout?.removeFromSuperview()
		currentButtonLayout = nil
	}

	func fontValueDidChange(pointSize: CGFloat) {
		view.attributedText.enumerateAttribute(.font, in: view.selectedRange, options: .longestEffectiveRangeNotRequired) { font, range, _ in
			if let font = font as? UIFont {
				let newFont = font.withSize(pointSize)
				view.addAttribute(.font, value: newFont, at: range)
			}
		}
	}

	func updateButtonsState(attributes: [NSAttributedString.Key : Any]) {
		updateFontSizeDisplayIfNeeded()

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

	func updateFontSizeDisplayIfNeeded() {
		var fontSize: CGFloat? = nil
		var fontSizeIsSingle = true

		if view.selectedRange.length == 0 {
			fontSize = (view.typingAttributes[.font] as? UIFont)?.pointSize
		}

		view.attributedText.enumerateAttribute(.font, in: view.selectedRange, options: .longestEffectiveRangeNotRequired) { (font, range, _) in
			guard let uiFont = font as? UIFont else {
				return
			}
			guard fontSize != nil else {
				fontSize = uiFont.pointSize
				return
			}

			if fontSize != uiFont.pointSize {
				fontSizeIsSingle = false
			}
		}

		if fontSizeIsSingle, let fontSize = fontSize {
			fontSizeLabel?.text = String("\(Int(fontSize))")
		}
	}
}

// MARK: - Private RichTextViewCoordinator make methods
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
		[
			ToolbarEditorButtonFactory.makeDownscaleButton { [weak self] in self?.updateFontSizeDisplayIfNeeded() },
			ToolbarEditorButtonFactory.makeUpscaleButton { [weak self] in self?.updateFontSizeDisplayIfNeeded() },
		]
	}

	func makeFontLabel() -> TextFieldControl {
		let fontSizeLabel = TextFieldControl()
		self.fontSizeLabel = fontSizeLabel
		updateFontSizeDisplayIfNeeded()
		return fontSizeLabel
	}
}
