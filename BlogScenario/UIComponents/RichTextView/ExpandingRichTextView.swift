//
//  ExpandingRuchTetView.swift
//  BlogScenario
//
//  Created by  userauto on 14.01.2021.
//

import SwiftUI
import Proton

struct ExpandingRichTextView: View {
	@Binding var text: String
	
	@State private var height: CGFloat?
	private let minHeight: CGFloat = 60

	var body: some View {
		RichTextView(text: $text, textDidChange: self.textDidChange)
			.frame(height: height ?? minHeight)
	}

	private func textDidChange(_ editorView: EditorView) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
			self.height = max(editorView.sizeThatFits(CGSize(width: Int.max, height: Int.max)).height, minHeight)
		}
	}
}
