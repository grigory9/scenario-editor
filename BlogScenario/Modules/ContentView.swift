//
//  ContentView.swift
//  BlogScenario
//
//  Created by  userauto on 07.01.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		ScenarioList()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(ModelData())
    }
}
