    //
    //  ColorHandler.swift
    //  PhotoColorPicker
    //
    //  Created by Nicholas LaBelle on 9/28/17.
    //  Copyright © 2017 LaBelle, Nicholas. All rights reserved.
    //
    
    import UIKit
    
    class ColorHandler: NSObject {
        var red = 0
        var blue = 0
        var green = 0
        var color: UIColor
        var image: UIImage
        init(_ color: UIColor, image: UIImage) {
            self.image = image
            self.color = color
            
        }
        
        private func calculateColors(){
            if let red = color.rgb()?.red {
                self.red = red
            }
            if let green = color.rgb()?.green {
                self.green = green        }
            if let blue = color.rgb()?.blue {
                self.blue = blue
            }
            
        }
        
        public func returnRGBColor() -> String {
            return "R:\(color.rgb()!.red), G:\(color.rgb()!.green), B:\(color.rgb()!.blue)"
        }
        public func returnHexColor() -> String {
            
            return "Hex:\(color.toHex()!)"
        }
        public func returnUIColor() -> UIColor{
            return color
        }
        
        public func returnUIImage() -> UIImage{
            return image
        }
        public func returnInverseColor() -> UIColor{
            return color.inverse()!
        }
        
        
    }
    
    extension UIImageView{
        func getPixelColorAtPoint(point:CGPoint) -> UIColor{
            
            let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            
            context!.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context!)
            let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                        green: CGFloat(pixel[1])/255.0,
                                        blue: CGFloat(pixel[2])/255.0,
                                        alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate(capacity: 4)
            return color
        }
    }
    extension UIColor {
        
        func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
            var fRed : CGFloat = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat = 0
            var fAlpha: CGFloat = 0
            if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                let iRed = Int(fRed * 255.0)
                let iGreen = Int(fGreen * 255.0)
                let iBlue = Int(fBlue * 255.0)
                let iAlpha = Int(fAlpha * 255.0)
                
                return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
            } else {
                // Could not extract RGBA components:
                return nil
            }
            
        }
        func toHex(alpha: Bool = false) -> String? {
            guard let components = cgColor.components, components.count >= 3 else {
                return nil
            }
            
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)
            
            if components.count >= 4 {
                a = Float(components[3])
            }
            
            if alpha {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }
        func inverse() -> UIColor? {
            var fRed : CGFloat = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat = 0
            var fAlpha: CGFloat = 0
            if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                let inRed = 1.0 - fRed/3
                let inGreen = 1.0 - fGreen/2
                let inBlue = 1.0 - fBlue/3
                let inAlpha = fAlpha
                
                return UIColor(red: inRed, green: inGreen, blue: inBlue, alpha: inAlpha)
            } else {
                // Could not extract RGBA components:
                return nil
            }
        }
        
    }
