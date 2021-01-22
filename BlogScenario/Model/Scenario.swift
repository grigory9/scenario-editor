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
	@Published var snapshots: [ScenarioContent]

	init(dto: ScenarioDto) {
		self.name = dto.name
		self.content = ScenarioContent(dto: dto.content)
		self.snapshots = dto.snapshots.map { ScenarioContent(dto: $0) }
	}
	
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		lhs.name == rhs.name
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.name)
		hasher.combine(self.content)
		hasher.combine(self.snapshots)
	}
}

struct ScenarioDto: Hashable, Codable {
	var name: String
	var content: ScenarioContentDto
	var snapshots: [ScenarioContentDto]
}
