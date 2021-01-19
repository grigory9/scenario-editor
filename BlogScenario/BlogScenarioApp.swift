//
//  BlogScenarioApp.swift
//  BlogScenario
//
//  Created by  userauto on 07.01.2021.
//

import SwiftUI

@main
struct BlogScenarioApp: App {
	@StateObject
	private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(modelData)
        }
    }
}
