//
//  ControlsLayout.swift
//  BlogScenario
//
//  Created by  userauto on 17.01.2021.
//

import UIKit

final class ControlsLayout: UIView {
	var controls: [UIView]

	struct Metrics {
		static let verticalInset: CGFloat = 4.0
		static let horizontalInset: CGFloat = 4.0
	}

	init(controls: [UIView]) {
		self.controls = controls
		super.init(frame: .null)
		configureLayout(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setKeyboard(frame: CGRect) {
		let bottomConstraint = self.superview?.bottomAnchor.constraint(equalTo: self.topAnchor, constant: (frame.maxY - frame.minY))
		self.superview?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -4.0).isActive = true
		bottomConstraint?.isActive = true
		self.superview?.layoutIfNeeded()

		bottomConstraint?.constant = (frame.maxY - frame.minY) + self.frame.height + Metrics.verticalInset
		UIView.animate(withDuration: 0.8,
					   delay: 0,
					   usingSpringWithDamping: 0.2,
					   initialSpringVelocity: 6,
					   options: .curveEaseOut) {
			self.superview?.layoutIfNeeded()
		} completion: { _ in }
	}
}

// MARK: - Private
private extension ControlsLayout {
	private func configureLayout(frame: CGRect) {
		layer.borderWidth = 2.0
		layer.borderColor = UIColor.systemGray3.cgColor

		backgroundColor = .systemGray5
		alpha = 0.95
		layer.cornerRadius = 8.0
		translatesAutoresizingMaskIntoConstraints = false

		let stackView = UIStackView(arrangedSubviews: controls)
		addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
		stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
		stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
		stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
		stackView.alignment = .center
		stackView.distribution = .equalSpacing
		stackView.axis = .horizontal
		stackView.spacing = 4.0
	}
}
