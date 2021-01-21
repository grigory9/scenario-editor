//
//  Scenario.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation

final class Scenario: ObservableObject, Identifiable, Hashable {

	@Published var name: String
	@Published var content: ScenarioContent

	init(dto: ScenarioDto) {
		self.name = dto.name
		self.content = ScenarioContent(dto: dto.content)
	}
	
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		lhs.name == rhs.name
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.name)
		hasher.combine(self.content)
	}
}

struct ScenarioDto: Hashable, Codable {
	var name: String
	var content: ScenarioContentDto
}
