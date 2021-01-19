//
//  ThemeRowView.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import SwiftUI
import Proton

struct ThemeRowView: View {
	@Binding var text: String
	@Binding var name: String

	@State private var isExpanded: Bool = false
	@State private var height: CGFloat = .zero

	var body: some View {
		VStack {
			Button(action: {
				isExpanded.toggle()
			}, label: {
				topContent
			})
			if isExpanded {
				ExpandingRichTextView(text: $text)
			}
		}
		.padding(4)
	}

	var topContent: some View {
		HStack {
			Text(name)
			Spacer()
			Image("Small Arrow Right")
				.rotationEffect(.degrees(isExpanded ? 90 : 0))
				.scaleEffect(isExpanded ? 1.5 : 1)
				.animation(.linear(duration: 0.1))
		}
	}
}

struct ThemeRowView_Previews: PreviewProvider {
	@ObservedObject static var model = ModelData()

	static var previews: some View {
		Group {
			ThemeRowView(text: $model.scenarios[0].themes[0].text,
						 name: $model.scenarios[0].themes[0].name)
		}
		.previewLayout(.fixed(width: 300, height: 150))
	}
}
