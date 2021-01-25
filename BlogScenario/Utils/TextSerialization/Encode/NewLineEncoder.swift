//
//  NewLineEncoder.swift
//  BlogScenario
//
//  Created by  userauto on 25.01.2021.
//

import Foundation
import UIKit

import Proton

struct NewLineEncoder: EditorTextEncoding {
	func encode(name: EditorContent.Name, string: NSAttributedString) -> JSON {
		var text = JSON()
		text["type"] = EditorContent.Name.newline.rawValue
		return text
	}
}
