//
//  NewLineDecoder.swift
//  BlogScenario
//
//  Created by  userauto on 25.01.2021.
//

import Foundation
import UIKit

import Proton

struct NewLineDecoder: EditorContentDecoding {
	func decode(mode: EditorContentMode, maxSize: CGSize, value: JSON) -> NSAttributedString {
		let string = NSMutableAttributedString(string: "\n")
		string.addAttribute(.blockContentType, value: EditorContent.Name.newline, range: string.fullRange)
		return string
	}
}
