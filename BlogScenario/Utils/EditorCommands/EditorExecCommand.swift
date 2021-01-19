//
//  Commands.swift
//  BlogScenario
//
//  Created by  userauto on 14.01.2021.
//

import Proton
import Foundation
import UIKit

enum EditorExecCommand {
	case strikeThrough
	case underscore
	case bold
	case italics
	case upscale
	case downscale
	case list(EditorView)

	func exec() {
		switch self {
		case .bold:
			EditorCommandExecutor().execute(self.commandValue)
		case .italics:
			EditorCommandExecutor().execute(self.commandValue)
		case .list(let editor):
			(self.commandValue as? ListCommand)?.execute(on: editor, attributeValue: "listItemValue")
		case .strikeThrough:
			EditorCommandExecutor().execute(self.commandValue)
		case .underscore:
			EditorCommandExecutor().execute(self.commandValue)
		case .upscale:
			EditorCommandExecutor().execute(self.commandValue)
		case .downscale:
			EditorCommandExecutor().execute(self.commandValue)
		}
	}

	var commandValue: EditorCommand {
		switch self {
		case .underscore:
			return FontStyleToggleCommand(key: NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue)
		case .strikeThrough:
			return FontStyleToggleCommand(key: NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
		case .bold:
			return FontTraitToggleCommand(name: CommandName("_BoldCommand"), trait: .traitBold)
		case .italics:
			return FontTraitToggleCommand(name: CommandName("_ItalicsCommand"), trait: .traitItalic)
		case .upscale:
			return FontResizeCommand(command: .upscale)
		case .downscale:
			return FontResizeCommand(command: .downscale)
		case .list(_):
			return ListCommand()
		}
	}
}
