//
//  FontStyleCommands.swift
//  BlogScenario
//
//  Created by  userauto on 18.01.2021.
//

import Foundation
import UIKit
import Proton

final class FontStyleToggleCommand: EditorCommand {
	lazy var name = CommandName(rawValue: key.rawValue)

	let key: NSAttributedString.Key
	let value: Int

	init(key: NSAttributedString.Key, value: Int) {
		self.key = key
		self.value = value
	}

	func execute(on editor: EditorView) {
		let selectedText = editor.selectedText
		if editor.isEmpty || editor.selectedRange == .zero {
			editor.typingAttributes[key] = value
			return
		}

		if selectedText.length == 0 {
			editor.typingAttributes[key] = value
			return
		}

		if selectedText.attribute(key, at: 0, effectiveRange: nil) != nil {
			editor.removeAttribute(key, at: editor.selectedRange)
		} else {
			editor.addAttribute(key, value: value, at: editor.selectedRange)
		}
	}
}
