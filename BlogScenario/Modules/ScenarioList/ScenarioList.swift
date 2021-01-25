//
//  ScenarioList.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import SwiftUI

struct ScenarioList: View {
	@EnvironmentObject var modelData: ModelData

    var body: some View {
		NavigationView {
			List(modelData.scenarios, id: \.id) { scenario in
				NavigationLink(destination: ScenarioDetailsView(scenario: scenario)) {
					ScenarioRowView(scenario: scenario)
				}
			}
			.navigationTitle("Scenarios")
			.navigationBarItems(leading: Button("Add", action: { modelData.scenarios.append(Scenario()) } ) )
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct ScenarioList_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioList()
    }
}
