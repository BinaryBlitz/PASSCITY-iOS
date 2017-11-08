//
//  InstructionCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class InstructionCell: UITableViewCell {
  @IBOutlet weak var instructionsStackView: UIStackView!

  var instructionViews: [InstructionView] {
    get {
      return instructionsStackView.arrangedSubviews as? [InstructionView] ?? []
    }
  }

  func configure(instructions: [String]) {
    for instruction in instructions {
      let view = InstructionView(instruction)
      instructionsStackView.addArrangedSubview(view)
    }
  }

	override func prepareForReuse() {
		super.prepareForReuse()
		for view in instructionViews  {
			instructionsStackView.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
	}
}


class InstructionView: UIView {
  let label = UILabel()
  let lineView = UIView()


  init(_ text: String) {
    super.init(frame: CGRect.null)
    label.text = "•   \(text)"
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
    addSubview(label)
	label.numberOfLines = 2
    label <- [
      Top(4),
      Bottom(4),
      Left(20),
      Right(20)
    ]
    addSubview(lineView)
    lineView <- [
      Height(0.5),
      Left(36.6)
    ]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
