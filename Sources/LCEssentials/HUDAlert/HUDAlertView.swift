//  
// Copyright (c) 2022 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

// MARK: - Framework headers
import UIKit

// MARK: - Protocols


// MARK: - Interface Headers


// MARK: - Local Defines / ENUMS


// MARK: - Class

public final class HUDAlertView: UIView {
    
    // MARK: - Private properties
    
    // MARK: - Internal properties
    
    lazy var containerView: UIView = {
        $0.isOpaque = true
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let rotatinProgress: RotatingCircularGradientProgressBar = {
        $0.layer.masksToBounds = true
        $0.color = .gray
        $0.gradientColor = .gray
        $0.ringWidth = 2
        $0.progress = 0
        return $0
    }(RotatingCircularGradientProgressBar())
    
    lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 22.0)
        $0.textColor = .black
        $0.backgroundColor = UIColor.clear
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var descLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16.0)
        $0.textColor = .black
        $0.backgroundColor = UIColor.clear
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var stackButtons: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10.0
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    // MARK: - Public properties
    
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero)
        
        insertBlurView(style: .dark, color: .clear, alpha: 0.8)
        
        addComponentsAndConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Super Class Overrides
 
    
    // MARK: - Private methods
    
    fileprivate func addComponentsAndConstraints() {
        
        // MARK: - Add Subviews
        
        containerView.addSubviews([rotatinProgress, titleLabel, descLabel, stackButtons])
        
        addSubviews([containerView])
        
        // MARK: - Add Constraints
        
        rotatinProgress
            .setConstraintsTo(containerView, .top, 10)
            .setConstraints(.centerX, 0)
        rotatinProgress.setWidth(size: 40)
        rotatinProgress.setHeight(size: 40)
        
        titleLabel
            .setConstraintsTo(rotatinProgress, .topToBottom, 8)
            .setConstraintsTo(containerView, .leading, 10)
            .setConstraints(.trailing, -10)
        
        descLabel
            .setConstraintsTo(titleLabel, .topToBottom, 8)
            .setConstraintsTo(containerView, .leading, 10)
            .setConstraints(.trailing, -10)
        
        stackButtons
            .setConstraintsTo(descLabel, .topToBottom, 8)
            .setConstraintsTo(containerView, .leading, 10)
            .setConstraints(.leading, 10)
            .setConstraints(.trailing, -10)
            .setConstraints(.bottom, -8)
        
        containerView
            .setConstraintsTo(self, .topToTopGreaterThanOrEqualTo, 20, true)
            .setConstraints(.leading, 40)
            .setConstraints(.trailing, -40)
            .setConstraints(.centerX, 0)
            .setConstraints(.centerY, 0)
    }
    
    // MARK: - Internal methods
}

// MARK: - Extensions
