//
//  ScenarioDetailsView.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import SwiftUI

struct ScenarioDetailsView: View {
	@State var scenario: Scenario

    var body: some View {
		VStack {
			ScrollView {
				ExpandingRichTextView(text: $scenario.content.text)
			}
			Spacer()
		}
		.navigationTitle("Themes")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct ScenarioDetailsView_Previews: PreviewProvider {
	@ObservedObject static var model = ModelData()
    static var previews: some View {
		ScenarioDetailsView(scenario: model.scenarios[0])
    }
}
