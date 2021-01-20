//
//  ToolbarEditorButtonFactory.swift
//  BlogScenario
//
//  Created by  userauto on 16.01.2021.
//

import Proton
import UIKit

enum ToolbarEditorButtonFactory {
	static func makeTextEditToolbarButton(didTapAction: @escaping ((ToolbarEditorButton) -> Void)) -> ToolbarEditorButton {
		ToolbarEditorButton(command: .none, icon: #imageLiteral(resourceName: "font")) {
			$0.isSelected = !$0.isSelected
			didTapAction($0)
		}
	}

	static func makeTextResizeButton(didTapAction: @escaping ((ToolbarEditorButton) -> Void)) -> ToolbarEditorButton {
		ToolbarEditorButton(command: .none, icon: #imageLiteral(resourceName: "resize")) {
			$0.isSelected = !$0.isSelected
			didTapAction($0)
		}
	}

	static func makeBoldButton() -> EditorButton {
		EditorButton(command: .bold, icon: #imageLiteral(resourceName: "bold")) {
			$0.isSelected = !$0.isSelected
		}
	}

	static func makeStrikeThroughButton() -> EditorButton {
		EditorButton(command: .strikeThrough, icon: #imageLiteral(resourceName: "strikethrough")) {
			$0.isSelected = !$0.isSelected
		}
	}

	static func makeUnderscoreButton() -> EditorButton {
		EditorButton(command: .underscore, icon: #imageLiteral(resourceName: "underline-1")) {
			$0.isSelected = !$0.isSelected
		}
	}

	static func makeItalicsButton() -> EditorButton {
		EditorButton(command: .italics, icon: #imageLiteral(resourceName: "italic")) {
			$0.isSelected = !$0.isSelected
		}
	}

	/// TODO: https://github.com/grigory9/scenario-editor/issues/1
	/// Remote didTap. When text changed EditorViewDelegate methods should be called. Otherwise it could result unconsistence
	static func makeUpscaleButton(didTap: @escaping (() -> Void)) -> EditorButton {
		EditorButton(command: .upscale, icon: #imageLiteral(resourceName: "upscale")) { button in
			button.isSelected = true
			didTap()
			UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) {
				button.isSelected = false
			} completion: { _ in }
		}
	}

	/// TODO: https://github.com/grigory9/scenario-editor/issues/1
	/// Remote didTap. When text changed EditorViewDelegate methods should be called. Otherwise it could result unconsistence
	static func makeDownscaleButton(didTap: @escaping (() -> Void)) -> EditorButton {
		EditorButton(command: .downscale, icon: #imageLiteral(resourceName: "downscale")) { button in
			button.isSelected = true
			didTap()
			UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut) {
				button.isSelected = false
			} completion: { _ in }
		}
	}

	static func makeListToolbarButton(with editor: EditorView) -> ToolbarEditorButton {
		ToolbarEditorButton(command: .list(editor), icon: #imageLiteral(resourceName: "list")) { _ in }
	}
}
