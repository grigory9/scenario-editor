//
//  MDTextEditor.swift
//  BlogScenario
//
//  Created by  userauto on 12.01.2021.
//

import SwiftUI
import Proton
import UIKit

final class RichTextView {
	private let textDidChange: (EditorView) -> Void

	private let view = EditorView()
	private var toolbarButtons: [ToolbarEditorButton] = []

	@Binding var text: String

	init(text: Binding<String>, textDidChange: @escaping (EditorView) -> Void) {
		self.textDidChange = textDidChange
		self._text = text
	}
}

// MARK: - UIViewRepresentable
extension RichTextView: UIViewRepresentable {
	typealias UIViewType = EditorView
	typealias Coordinator = RichTextViewCoordinator

	func makeCoordinator() -> Coordinator {
		Coordinator(view: view, textDidChange: textDidChange, text: $text)
	}

	func updateUIView(_ uiView: EditorView, context: Context) {
		textDidChange(uiView)
	}

	func makeUIView(context: Context) -> EditorView {
		view.delegate = context.coordinator

		let listFormattingProvider = ListFormattingProvider()
		context.coordinator.listFormattingProvider = listFormattingProvider
		view.listFormattingProvider = listFormattingProvider
		view.registerProcessor(ListTextProcessor())

		let coordinator = context.coordinator
		let toolBar = makeToolBar(
			didTapEditFont: { [weak coordinator] in coordinator?.didTapEditFont($0) },
			didTapTextResize: { [weak coordinator] in coordinator?.didTapTextResize($0) }
		)
		context.coordinator.toolbarButtons = toolbarButtons

		view.editorInputAccessoryView = toolBar

		return view
	}
}

// MARK: - Private
private extension RichTextView {
	func makeToolBar(didTapEditFont: @escaping ((ToolbarEditorButton) -> Void),
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
