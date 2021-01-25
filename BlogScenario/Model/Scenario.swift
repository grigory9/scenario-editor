//
//  Scenario.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation

final class Scenario: ObservableObject, Identifiable, Hashable {

	let id: UUID

	@Published var name: String
	@Published var content: ScenarioContent
	@Published var snapshots: [ScenarioContent]

	init(dto: ScenarioDto) {
		id = dto.id
		name = dto.name
		content = ScenarioContent(dto: dto.content)
		snapshots = dto.snapshots.map { ScenarioContent(dto: $0) }
	}

	init() {
		id = UUID()
		name = ""
		content = ScenarioContent()
		snapshots = []
	}

	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}
