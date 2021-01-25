//
//  ScenarioContentDto.swift
//  BlogScenario
//
//  Created by  userauto on 22.01.2021.
//

import Foundation

struct ScenarioContentDto: Hashable, Codable, Identifiable {
	var id: UUID
	var text: String
}

extension ScenarioContentDto {
	init(from model: ScenarioContent) {
		id = model.id
		text = model.text
	}
}
