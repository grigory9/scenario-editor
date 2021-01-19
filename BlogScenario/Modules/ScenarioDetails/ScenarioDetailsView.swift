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
			forEach
		}
		.navigationTitle("Themes")
		.navigationBarTitleDisplayMode(.inline)
	}

	var forEach: some View {
		ScrollView {
			ForEach(scenario.themes.indices) { index in
				ThemeRowView(text: $scenario.themes[index].text,
							 name: $scenario.themes[index].name)
					.animation(.linear(duration: 0.1))
			}
		}
		.padding(8)
	}
}

struct ScenarioDetailsView_Previews: PreviewProvider {
	@ObservedObject static var model = ModelData()
    static var previews: some View {
		ScenarioDetailsView(scenario: model.scenarios[0])
    }
}
