//
//  FDMExtension.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/30.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import CommonCrypto

extension UIView {
    
    /*==================
     1.【Class】创建毛玻璃
     2.截取View作为图片
     3.通过Bezier创建某个圆角
    ==================*/
    
    /// 1.创建毛玻璃
    class func groundGlass(style:UIBlurEffect.Style) -> UIView{
        let blurEddect = UIBlurEffect(style:style)
        let blurView = UIVisualEffectView(effect: blurEddect)
        return blurView.contentView
    }
    
    /// 2.截取View作为图片
    func toImage() -> UIImage {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let screenRect = self.bounds
        UIGraphicsBeginImageContext(screenRect.size)
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
    
    /// 3.通过Bezier创建某个圆角 -corner:某个角或多个角,多个角传UIRectCorner(rawValue:),四个角传.allCorners
    func roundedCorners(corner:UIRectCorner,size:Double){
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let cornerLaye = CAShapeLayer.init()
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii:CGSize(width: size, height: size))
        cornerLaye.path = maskPath.cgPath
        cornerLaye.frame = self.bounds
        self.layer.mask = cornerLaye
    }
    
}

extension String {
    /*==================
     1.Base64 编解码
     2.MD5加密
     3.字符串尺寸
     4.从字符串URL中截取参数
     5.复制字符串到剪切板
     6.正则表达式查找字符
     7.JsonString转为Dictionary <String,Any>
     8.JsonArray 转 DictionArray
     9.返回该Hex值的颜色
     10.获取网络图片尺寸
     11.生成二维码图片
     12.生成条形码图片
     13.获取当前名称的本地图片
    ==================*/
    
    /// 1.Base64 编解码 -encode: true:编码 false:解码 需要先将占位符换为=
    func base64(encode: Bool) -> String? {
        if encode { // 编码
            guard let codingData = self.data(using: .utf8) else {return nil}
            return codingData.base64EncodedString()
        } else { // 解码
            guard !self.isEmpty else {return nil}
            
            guard let decryptionData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return String.init(data: decryptionData, encoding: .utf8)
        }
    }
    
    /// 2.MD5加密 -string:字符 -lower:true为小写，false为大写
    func md5(string: String?, lower: Bool = true) -> String?{
        guard let cStr = string?.cString(using: .utf8) else {
            return nil
        }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer) // import CommonCrypto
        let md5String = NSMutableString();
        for i in 0 ..< 16 {
            if lower {
                md5String.appendFormat("%02x", buffer[i])
            } else {
                md5String.appendFormat("%02X", buffer[i])
            }
        }
        free(buffer)
        return md5String as String
    }
    
    /// 3.字符串尺寸
    func size(font: UIFont, w: CGFloat, h: CGFloat = 0) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = self.boundingRect(with: CGSize(width: w, height: h), options: option, attributes: attributes, context: nil)
        
        return rect
    }
    
    /// 4.从字符串URL中截取参数
    func paramsWithURL() -> [String:String]?{
        guard let components = URLComponents(url: URL(string: self)!, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    /// 5.复制字符串到剪切板
    func copyToClipboard() -> Bool{
        let pab = UIPasteboard.general
        pab.string = self
        
        if pab.string != nil{
            return true
        }else{
            return false
        }
    }
    
    /// 6.正则表达式查找字符 pattern:正则表达式 返回ture:验证成功
    func regularExpression(pattern:String) -> Bool{
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex?.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count))
        
        if matches?.count != 0 {
            return true
        }else{
            return false
        }
    }
    
    /// 7.JsonString转为Dictionary <String,Any>
     func toDictionary() -> Dictionary<String,Any>?{
         do {
         let dic = try JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
         
             return dic
         }catch{
             return ["String解析失败":"JsonString转Dictionary【失败】"]
         }
     }
    
    /// 8.JsonArray 转 DictionArray
    func toDiction_Array() -> NSArray {
        let jsonData: Data = self.data(using: .utf8)!
        
        do {
            let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            
            return array as! NSArray
        } catch {
            return ["JsonArray 转 DictionArray失败"]
        }
    }
    
    /// 9.返回该Hex值的颜色
    func Hex(alpha:CGFloat = 1) -> UIColor? {
        if self.hasPrefix("#") && self.count == 7 {
            return UIColor.Hex(hexString: self, alpha: alpha)
        }
        
        return nil
    }
    
    
    /// 10.获取网络图片尺寸
    func imageSizeFromUrl() -> CGSize {
        guard !self.isEmpty else {return CGSize.zero}
        
        let tempUrl = URL(string: self)
        let imageSourceRef = CGImageSourceCreateWithURL(tempUrl! as CFURL, nil)
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if let imageSRef = imageSourceRef {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
            if let imageP = imageProperties {
                let imageDict = imageP as Dictionary
                
                width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /// 11.生成二维码图片
    func imageQRCode() -> UIImage?{
        let context = CIContext()
        let data = self.data(using: .utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)
            
            if let output = filter.outputImage?.transformed(by: transform){
                let cgImage = context.createCGImage(output, from: output.extent)
                return UIImage(cgImage: cgImage!)
            }
        }
        return nil
    }
    
    /// 12.生成条形码图片
    func imageBarCode(color0: CIColor? , color1: CIColor?) -> UIImage{
        // 注意生成条形码的编码方式
        let data = self.data(using: .utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(NSNumber(value: 0), forKey: "inputQuietSpace")
        let outputImage = filter?.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(outputImage, forKey: "inputImage")
        colorFilter.setValue(color0 ?? CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(color1 ?? CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
        // 返回条形码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 10, y: 10))))
        return codeImage
    }
    
    /// 13.获取当前名称的本地图片
    func image() -> UIImage? {
        return UIImage(named: self)
    }
}

extension UIColor {
    
    /*==================
     1.【Class】RGB颜色快捷方式
     2.【Class】十六进制RGB
     3.【Class】随机色
     4.【Class】创建渐变色Layer
     5.获取当前颜色的rgb值
     6.通过颜色返回一张图片
    ==================*/
    
    /// 1.RGB颜色快捷方式
    class func RGBA(r:Float,g:Float,b:Float,a:CGFloat = 1) -> UIColor{
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: a)
    }
    
    /// 2.十六进制RGB
    class func Hex(hexString hex: String, alpha:CGFloat = 1) -> UIColor {
        // 去除空格等
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        // 必须为6位
        if (cString.count != 6) {
            return UIColor.gray
        }
        // 红色的色值
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /// 3.随机色
    class func random() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 4.创建渐变色Layer  frame: layer大小  colors:渐变颜色数组  pointAry:[渐变起点0，渐变终点1] locations: 按照值颜色变化[0 - 1]
    class func gradationLayer(frame:CGRect,colors:Array<CGColor>,points:Array<CGPoint>,locations:Array<NSNumber>) -> CAGradientLayer{
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = points.first ?? CGPoint(x: 0,y: 0)
        gradientLayer.endPoint = points.last ?? CGPoint(x: 1,y: 1)
        gradientLayer.locations = locations
        
        return gradientLayer
    }
    
    /// 5.获取当前颜色的rgb值
    func colorWithRGB() -> Array<CGFloat>{
        let rgbValue = String(format: "%@", self)
        let regArr = rgbValue.components(separatedBy:" ")
        
        var getR:Float?
        var getG:Float?
        var getB:Float?
        var getA:Float?
        
        if regArr.count == 3 {
            getR = (regArr[1] as NSString).floatValue
            getG = (regArr[1] as NSString).floatValue
            getB = (regArr[1] as NSString).floatValue
            getA = (regArr[2] as NSString).floatValue
        }else{
            getR = (regArr[1] as NSString).floatValue
            getG = (regArr[2] as NSString).floatValue
            getB = (regArr[3] as NSString).floatValue
            getA = (regArr[4] as NSString).floatValue
        }
        
        return [CGFloat(getR!),CGFloat(getG!),CGFloat(getB!),CGFloat(getA!)]
    }
    
    /// 6.通过颜色返回一张图片
    func toImage() -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

extension UIImage {
    /*==================
     1.【Class】通过颜色返回一张图片
     2.【Class】获取网络图片尺寸
     3.【Class】截取View作为图片 view:被设置的View包括子视图会转为图片
     4.【Class】生成二维码图片
     5.【Class】生成条形码图片
    ==================*/
    
    /// 1.通过颜色返回一张图片
    class func imageFromColor(_ color: UIColor) -> UIImage {
        return color.toImage()
    }
    
    /// 2.获取网络图片尺寸
    class func imageSizeFromUrl(_ url: String) -> CGSize {
        return url.imageSizeFromUrl()
    }
    
    /// 3.截取View作为图片 view:被设置的View包括子视图会转为图片
    class func imageFromView(_ view:UIView) -> UIImage {
        return view.toImage()
    }
    
    /// 4.生成二维码图片
    class func imageQRCodeFromString(_ str:String) -> UIImage?{
        return str.imageQRCode()
    }
    
    /// 5.生成条形码图片
    class func imageBarCodeFromString(_ str:String) -> UIImage{
        return str.imageBarCode(color0: nil, color1: nil)
    }
}

extension Array {
    /// 数组转json
    func toJSONString() -> String {
        let array = self as NSArray
        return array.toJSONString()
    }
}

extension NSArray {
    /// 数组转json
    func toJSONString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return "FDMQuick解析失败,数组转json【失败】"
        }
         
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}

extension Dictionary {
    /// Dictionary<String,Any>转Json字符串
    func toJSONString() -> String{
        let dictionary = self as NSDictionary
        return dictionary.toJSONString()
    }
}

extension NSDictionary {
    /// Dictionary<String,Any>转Json字符串
    func toJSONString() -> String{
        if (!JSONSerialization.isValidJSONObject(self)) {
            return "Dictionary解析失败,Dictionary<String,Any>转Json字符串【失败】"
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
