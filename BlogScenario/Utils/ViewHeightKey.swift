//
//  ViewHeightKey.swift
//  BlogScenario
//
//  Created by  userauto on 12.01.2021.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}
