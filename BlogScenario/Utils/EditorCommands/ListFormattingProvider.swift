//
//  ListFormattingProvider.swift
//  BlogScenario
//
//  Created by  userauto on 16.01.2021.
//

import Foundation
import Proton

class ListFormattingProvider: EditorListFormattingProvider {
	let listLineFormatting: LineFormatting = LineFormatting(indentation: 25, spacingBefore: 0)
	let sequenceGenerators: [SequenceGenerator] =
		[NumericSequenceGenerator(),
		 DiamondBulletSequenceGenerator(),
		 SquareBulletSequenceGenerator()]

	func listLineMarkerFor(editor: EditorView, index: Int, level: Int, previousLevel: Int, attributeValue: Any?) -> ListLineMarker {
		let sequenceGenerator = self.sequenceGenerators[(level - 1) % self.sequenceGenerators.count]
		return sequenceGenerator.value(at: index)
	}
}
