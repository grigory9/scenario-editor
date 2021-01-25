//
//  Theme.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation

final class ScenarioContent: ObservableObject, Identifiable, Hashable {

	var id: UUID
	
	@Published var text: String

	init(dto: ScenarioContentDto) {
		id = dto.id
		text = dto.text
	}

	init() {
		id = UUID()
		text = ""
	}

	static func == (lhs: ScenarioContent, rhs: ScenarioContent) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
