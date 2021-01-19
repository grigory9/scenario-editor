//
//  FontResizeCommand.swift
//  BlogScenario
//
//  Created by  userauto on 19.01.2021.
//

import UIKit
import Proton

final class FontResizeCommand: EditorCommand {
	var name: CommandName = CommandName("_ResizeCommand")

	enum ResizeCommand {
		case upscale
		case downscale
	}

	let command: ResizeCommand

	init(command: ResizeCommand) {
		self.command = command
	}

	func execute(on editor: EditorView) {
		let selectedText = editor.selectedText
		if editor.isEmpty || editor.selectedRange == .zero {
			guard let font = editor.typingAttributes[.font] as? UIFont else { return }
			changeSize(editor: editor, for: font)
			return
		}

		if selectedText.length == 0 {
			guard let font = editor.attributedText.attribute(.font, at: editor.selectedRange.location - 1, effectiveRange: nil) as? UIFont else { return }
			changeSize(editor: editor, for: font)
			return
		}

		editor.attributedText.enumerateAttribute(.font, in: editor.selectedRange, options: .longestEffectiveRangeNotRequired) { font, range, _ in
			if let font = font as? UIFont {
				changeSize(editor: editor, for: font, with: range)
			}
		}
	}
}

// MARK: - Private
private extension FontResizeCommand {
	func changeSize(editor: EditorView, for font: UIFont, with range: NSRange? = nil) {
		let newFont: UIFont
		switch command {
		case .upscale:
			newFont = font.withSize(font.pointSize + 1)
		case .downscale:
			newFont = font.withSize(font.pointSize - 1)
		}

		if let range = range {
			editor.addAttribute(.font, value: newFont, at: range)
		} else {
			editor.typingAttributes[.font] = newFont
		}
	}
}
