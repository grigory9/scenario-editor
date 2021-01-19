//
//  Theme.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation

final class Theme: ObservableObject, Identifiable, Hashable {

	var id: Int
	
	@Published var name: String
	@Published var text: String

	init(dto: ThemeDto) {
		self.id = dto.id
		self.name = dto.name
		self.text = dto.text
	}

	static func == (lhs: Theme, rhs: Theme) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
		hasher.combine(self.name)
	}
}


struct ThemeDto: Hashable, Codable, Identifiable {
	var id: Int
	var name: String
	var text: String
}
