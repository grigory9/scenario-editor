//
//  MDTextEditor.swift
//  BlogScenario
//
//  Created by  userauto on 12.01.2021.
//

import SwiftUI
import Proton
import UIKit

final class RichTextView: UIViewRepresentable {
	typealias UIViewType = EditorView
	typealias Coordinator = RichTextViewCoordinator

	let textDidChange: (EditorView) -> Void

	let view = EditorView()
	var toolbarButtons: [ToolbarEditorButton] = []

	@Binding var text: String

	func makeCoordinator() -> Coordinator {
		Coordinator(view: view, textDidChange: textDidChange)
	}

	init(text: Binding<String>, textDidChange: @escaping (EditorView) -> Void) {
		self.textDidChange = textDidChange
		self._text = text
	}

	func updateUIView(_ uiView: EditorView, context: Context) {
		textDidChange(uiView)
	}

	func makeUIView(context: Context) -> EditorView {
		view.delegate = context.coordinator
		view.placeholderText = NSAttributedString(string: text)
		view.attributedText = NSAttributedString(string: text)

		let listFormattingProvider = ListFormattingProvider()
		context.coordinator.listFormattingProvider = listFormattingProvider
		view.listFormattingProvider = listFormattingProvider
		view.registerProcessor(ListTextProcessor())

		let toolBar = makeToolBar(didTapEditFont: context.coordinator.didTapEditFont,
								  didTapTextResize: context.coordinator.didTapTextResize)
		context.coordinator.toolbarButtons = toolbarButtons

		view.editorInputAccessoryView = toolBar

		return view
	}

	private func makeToolBar(didTapEditFont: @escaping ((ToolbarEditorButton) -> Void),
							 didTapTextResize: @escaping ((ToolbarEditorButton) -> Void)) -> UIToolbar {
		let toolBar = UIToolbar()

		toolbarButtons = [
			ToolbarEditorButtonFactory.makeTextEditToolbarButton(didTapAction: didTapEditFont),
			ToolbarEditorButtonFactory.makeTextResizeButton(didTapAction: didTapTextResize),
		]

		var uiBarItems = toolbarButtons.map { UIBarButtonItem(customView: $0) }
		uiBarItems.append(UIBarButtonItem(systemItem: .flexibleSpace))

		toolBar.items = uiBarItems

		toolBar.sizeToFit()
		return toolBar
	}
}
