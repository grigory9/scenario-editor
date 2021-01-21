//
//  Theme.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation

final class ScenarioContent: ObservableObject, Identifiable, Hashable {

	var id: Int
	
	@Published var text: String

	init(dto: ScenarioContentDto) {
		self.id = dto.id
		self.text = dto.text
	}

	static func == (lhs: ScenarioContent, rhs: ScenarioContent) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

struct ScenarioContentDto: Hashable, Codable, Identifiable {
	var id: Int
	var text: String
}
