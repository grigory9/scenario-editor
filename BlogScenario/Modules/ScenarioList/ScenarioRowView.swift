//
//  ScenarioRowView.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import SwiftUI

struct ScenarioRowView: View {
	let scenario: Scenario

    var body: some View {
		HStack {
			UmaruGifView()
				.frame(width: 100, height: 100, alignment: .center)
			Text(scenario.name)
			Spacer()
		}
    }
}

struct ScenarioRowView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ScenarioRowView(scenario: ModelData().scenarios[0])
			ScenarioRowView(scenario: ModelData().scenarios[1])
			ScenarioRowView(scenario: ModelData().scenarios[2])
		}
		.previewLayout(.fixed(width: 300, height: 70))
    }
}
