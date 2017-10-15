//
//  CardFooterView.swift
//  PASSCITY
//
//  Created by Алексей on 15.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardFooterView: UIView {
  let regulationsIconView = UIImageView(image: #imageLiteral(resourceName: "iconTetleRegulations"))
  let titleLabel = UILabel()
  let documentsStackView = UIStackView()

  var handler: ((PassCityCard.Doc) -> Void)? = nil

  init() {
    super.init(frame: CGRect.null)

    documentsStackView.axis = .vertical
    documentsStackView.distribution = .fillEqually

    addSubview(regulationsIconView)
    addSubview(titleLabel)
    addSubview(documentsStackView)

    titleLabel.text = "Правила и условия"
    titleLabel.font = UIFont.systemFont(ofSize: 12)

    regulationsIconView <- [
      Top(24),
      Left(20)
    ]

    titleLabel <- [
      CenterY().to(regulationsIconView),
      Left(6).to(regulationsIconView)
    ]

    documentsStackView <- [
      Top(10).to(titleLabel),
      Left(20),
      Right(),
      Bottom(20)
    ]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(card: PassCityCard) {
    documentsStackView.arrangedSubviews.forEach { [weak self] view in
      self?.documentsStackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }

    for document in card.docs {
      let itemView = DocumentItemView(title: document.title)
      itemView.handler = { [weak self] in
        self?.handler?(document)
      }
      
      documentsStackView.addArrangedSubview(itemView)
    }
  }

  class DocumentItemView: UIView {
    let button = UIButton(type: .system)
    let label = UILabel()
    let lineView = UIView()
    let iconArrowView = UIImageView(image: #imageLiteral(resourceName: "iconArrowRight"))

    var handler: (() -> Void)? = nil

    init(title: String) {
      super.init(frame: CGRect.null)
      label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
      label.text = title

      lineView.backgroundColor = UIColor.disabledBtnColor

      addSubview(label)
      addSubview(lineView)
      addSubview(iconArrowView)
      addSubview(button)

      label <- [
        Left(),
        Top(8),
        Bottom(8).to(lineView, .top)
      ]

      lineView <- [
        Bottom(),
        Height(0.5),
        Left(),
        Right()
      ]

      iconArrowView <- [
        Right(20),
        CenterY(),
        Left(>=5).to(label, .right)
      ]

      iconArrowView.contentMode = .scaleAspectFit
      iconArrowView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

      button <- Edges()

      button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func buttonAction() {
      handler?()
    }
  }

}


