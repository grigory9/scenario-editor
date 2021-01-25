//
//  ModelData.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import Foundation
import Combine

final class ModelData: ObservableObject {

	@Published var scenarios: [Scenario] = []
	private var scenarioSubscriptions: Set<AnyCancellable> = []
	private var contentSubscriptions: Set<AnyCancellable> = []

	private var file: URL {
		guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("Documents folder should exist")
		}

		return documentsDir.appendingPathComponent("Scenarios")
	}

	init() {
		loadScenarios()

		$scenarios.sink {
			if $0.count == 0 {
				return
			}
			self.contentSubscriptions.removeAll()
			$0.forEach { (scenario) in
				scenario.$content.sink { _ in
					self.saveScenarios()
				}
				.store(in: &self.contentSubscriptions)
			}
			self.saveScenarios()
		}
		.store(in: &scenarioSubscriptions)
	}
}

// MARK: - Private
private extension ModelData {
	func saveScenarios() {
		let encoder = Foundation.JSONEncoder()
		let dtos = scenarios.map { ScenarioDto(from: $0) }
		do {
			let data = try encoder.encode(dtos)
			try data.write(to: file)
		} catch(let error) {
			assertionFailure(error.localizedDescription)
		}
	}

	func loadScenarios() {
		let data: Data
		do {
			data = try Data(contentsOf: file)
		} catch {
			return
		}

		do {
			let decoder = Foundation.JSONDecoder()
			let dtos = try decoder.decode([ScenarioDto].self, from: data)
			scenarios = dtos.map { Scenario(dto: $0) }
		} catch {
			assertionFailure("Couldn't decode content")
			return
		}
	}
}

func load<T: Decodable>(_ filename: String) -> T {
	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
	else {
		fatalError("Couldn't find \(filename) in main bundle.")
	}

	let data: Data
	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}

	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
