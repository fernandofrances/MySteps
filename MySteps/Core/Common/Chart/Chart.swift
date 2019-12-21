//
//  Chart.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

struct PointEntry {
    let value: Int
    let label: String
}

extension PointEntry: Comparable {
    static func <(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value < rhs.value
    }
    static func ==(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}

class Chart: UIView {
    
    private let dataLayer: CALayer = CALayer()
    private let mainLayer: CALayer = CALayer()
    private let mainView: UIView = UIView()
    private let gridLayer: CALayer = CALayer()
    private var dataPoints: [CGPoint]?
    
    let topSpace: CGFloat = 20.0
    let bottomSpace: CGFloat = 30.0
    let topHorizontalLine: CGFloat = 120.0 / 100.0
    var maxNumberOfColumns: Int = 7
    let maxNumberOfRows: Int = 4
    
    var columnSpace: CGFloat {
        return (self.bounds.size.width - 20)/CGFloat(maxNumberOfColumns)
    }
    var pointSpace: CGFloat {
        return (dataLayer.bounds.width - 50)/CGFloat(dataEntries?.count ?? 1)
    }
    
    var dataEntries: [PointEntry]? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        mainLayer.addSublayer(dataLayer)
        mainView.layer.addSublayer(mainLayer)
        self.layer.addSublayer(gridLayer)
        self.addSubview(mainView)
        self.backgroundColor = UIColor.backgroundColor
    }
    
    override func layoutSubviews() {
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        if let dataEntries = dataEntries {
            mainLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            dataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
            dataPoints = convertDataEntriesToPoints(entries: dataEntries)
            gridLayer.frame = CGRect(x: 0, y: topSpace, width: self.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
            clean()
            drawHorizontalLines()
            drawCurvedChart()
            drawLables()
        }
    }
    
    private func convertDataEntriesToPoints(entries: [PointEntry]) -> [CGPoint] {
        if let max = entries.max()?.value,
            let min = entries.min()?.value {
            
            var result: [CGPoint] = []
            let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine
            
            for i in 0..<entries.count {
                let height = (dataLayer.frame.height - 6) * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(i)*pointSpace + 24, y: height)
                result.append(point)
            }
            return result
        }
        return []
    }
    
    private func drawCurvedChart() {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return
        }
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 4
            lineLayer.strokeColor = UIColor.white.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: dataLayer.bounds.size.width, height: dataLayer.bounds.size.height)
            gradient.colors = [
                UIColor.gradientTopColor.cgColor,
                UIColor.gradientBottomColor.cgColor
            ]
            gradient.mask = lineLayer
            
            dataLayer.addSublayer(gradient)
        }
    }
    
    private func drawLables() {
        if let dataEntries = dataEntries {
            maxNumberOfColumns = dataEntries.count < maxNumberOfColumns ? dataEntries.count : maxNumberOfColumns
            if maxNumberOfColumns > 0 {
                let indexGap = dataEntries.count / maxNumberOfColumns
                var i = 0
                var n = 0
                while (n < maxNumberOfColumns && i <= dataEntries.count) {
                    let textLayer = CATextLayer()
                    textLayer.frame = CGRect(x: columnSpace*CGFloat(n) + 24, y: mainLayer.frame.size.height - bottomSpace/2 - 4, width: columnSpace, height: 16)
                    textLayer.foregroundColor = UIColor.chartTextColor.cgColor
                    textLayer.backgroundColor = UIColor.clear.cgColor
                    textLayer.contentsScale = UIScreen.main.scale
                    textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                    textLayer.fontSize = 11
                    textLayer.string = dataEntries[i].label
                    mainLayer.addSublayer(textLayer)
                    n += 1
                    if i > 0 {
                        i += indexGap + 1
                    } else {
                        i += indexGap
                    }
                }
            }
        }
    }
    
    private func drawHorizontalLines() {
        guard let dataEntries = dataEntries else {
            return
        }
        
        var gridValues: [CGFloat]? = nil
        if dataEntries.count < 3 && dataEntries.count > 0 {
            gridValues = [0, 1]
        } else if dataEntries.count >= 4 {
            gridValues = [0, 0.33, 0.66, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor.chartTextColor.cgColor
                lineLayer.lineWidth = 0.5
                
                gridLayer.addSublayer(lineLayer)
                
                var minMaxGap: CGFloat = 0
                var lineValue:Int = 0
                if let max = dataEntries.max()?.value,
                    let min = dataEntries.min()?.value {
                    minMaxGap = CGFloat(max - min) * topHorizontalLine
                    lineValue = Int((1-value) * minMaxGap) + Int(min)
                }
                
                var rounded: Int = 0
                if minMaxGap < 4000 {
                    rounded = Int(round(Double(lineValue/100)) * 100)
                } else {
                    rounded = Int(round(Double(lineValue/1000)) * 1000)
                }
                
                let textLayer = CATextLayer()
                textLayer.foregroundColor = UIColor.chartTextColor.cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = 12
                textLayer.alignmentMode = "right"
                textLayer.string = "\(rounded)"
                textLayer.frame = CGRect(x: self.gridLayer.bounds.size.width - 60, y: height - 17, width: 50, height: 16)
                
                gridLayer.addSublayer(textLayer)
            }
        }
    }
    
    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
   

}
