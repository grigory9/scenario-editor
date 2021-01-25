//
//  ScenarioDto.swift
//  BlogScenario
//
//  Created by  userauto on 22.01.2021.
//

import Foundation

struct ScenarioDto: Hashable, Codable {
	let id: UUID
	let name: String
	let content: ScenarioContentDto
	let snapshots: [ScenarioContentDto]
}

extension ScenarioDto {
	init(from model: Scenario) {
		id = model.id
		name = model.name
		content = ScenarioContentDto(from: model.content)
		snapshots = model.snapshots.map { ScenarioContentDto(from: $0) }
	}
}
