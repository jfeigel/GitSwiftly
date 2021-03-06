//
//  TextWithAttributedString.swift
//  GitSwiftly
//
//  Created by jfeigel on 2/8/20.
//  Copyright © 2020 jfeigel. All rights reserved.
//

import SwiftUI

struct TextWithAttributedString: UIViewRepresentable {
    var attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> ViewWithLabel {
        let view = ViewWithLabel(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: ViewWithLabel, context: Context) {
        uiView.setString(attributedString)
    }
}

class ViewWithLabel: UIView {
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.numberOfLines = 0
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setString(_ attributedString: NSAttributedString) {
        self.label.attributedText = attributedString
    }
    
    override var intrinsicContentSize: CGSize {
        label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 50, height: 9999))
    }
}
