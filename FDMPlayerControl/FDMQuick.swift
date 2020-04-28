//
//  FDMQuick.swift
//
//  Created by FDM on 2019/8/26.
//  Copyright © 2019 发抖喵. All rights reserved.
//

import UIKit
import Foundation

// 屏幕高度
let FScreenH = UIScreen.main.bounds.height
// 屏幕宽度
let FScreenW = UIScreen.main.bounds.width

// 手机型号
enum PhoneModel {
    case iPhone4_4s_5_5s_5c
    case iPhone6_6s_7_8
    case iPhone6P_6sP_7P_8p
    case iPhone_X
    case iPhone_XR
    case iPhone_XS
    case iPhone_XS_Max
    case otherFullScreen
}

class FDMQuick: NSObject {
    
    static let shared = FDMQuick.init()
    
    ///创建单击消失的背景Btn,将要消失时回调
    var btnWillCancelBlock: (() -> ())?
    ///创建单击消失的背景Btn,已经消失回调
    var btnDidCancelBlock: (() -> ())?
    
    //为view添加拖拽手势
    private var centerPoint:CGPoint?    //点击时view的center
    private var pointView:CGPoint?      //pointView:点击的位置
    
    //为view添加弹出提示框
    private var bgTipsView:UIView?   //背景view
    private var tipsView:UIView?     //弹出view
}


//MARK:- View   ----------------------------------------------------------------------
extension FDMQuick {
    
    /*==================
     1.创建毛玻璃
     2.通过路径创建某个圆角
     3.为View添加边框,并通过添加顺序返回边框Layer
     4.根据view数量进行平均分布局
     5.创建单击消失的背景Btn
    ==================*/
    
    /// 1.创建毛玻璃 -通过UIVisualEffectView.contentView添加子控件
    func viewGroundGlass(style:UIBlurEffect.Style) -> UIVisualEffectView{
        let blurEddect = UIBlurEffect(style:style)
        let blurView = UIVisualEffectView(effect: blurEddect)
        return blurView
    }
    
    /// 2.通过路径创建某个圆角 -corner:某个角或多个角,多个角传UIRectCorner(rawValue:),四个角传.allCorners
    func viewRoundedCorners(view:UIView,corner:UIRectCorner,size:Double){
        view.layoutIfNeeded()
        let cornerLaye = CAShapeLayer.init()
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii:CGSize(width: size, height: size))
        cornerLaye.path = maskPath.cgPath
        cornerLaye.frame = view.bounds
        view.layer.mask = cornerLaye
    }
    
    /// 3.为View添加边框,并通过添加顺序返回边框Layer
    func viewIncreaseBorder(view:UIView,direction:Array<UIRectEdge>,width:CGFloat,color:UIColor) -> Array<CALayer>{
        view.layoutIfNeeded()
        var layerAry = Array<CALayer>.init()
        for i in direction{
            switch i {
            case .left:
               let leftLayer = createBorderLayer(view: view, frame: CGRect(x: 0, y: 0, width: width, height: view.bounds.height), color: color)
               layerAry.append(leftLayer)
            case .top:
                let topLayer = createBorderLayer(view: view, frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: width), color: color)
                layerAry.append(topLayer)
            case .right:
                let rightLayer = createBorderLayer(view: view, frame: CGRect(x: view.bounds.width - width, y: 0, width: width, height: view.bounds.height), color: color)
                layerAry.append(rightLayer)
            case .bottom:
                let bottomLayer = createBorderLayer(view: view, frame: CGRect(x: 0, y: view.bounds.height - width, width: view.bounds.width, height: width), color: color)
                layerAry.append(bottomLayer)
            case .all:
                layerAry = self.viewIncreaseBorder(view: view, direction: [.left,.top,.right,.bottom], width: width, color: color)
            default:
                debugPrint("nil")
            }
        }
        
        return layerAry
    }
    
    /// 创建边框Layer
    private func createBorderLayer(view:UIView,frame:CGRect,color:UIColor) -> CALayer{
        let layer = CALayer.init()
        layer.backgroundColor = color.cgColor
        layer.frame = frame
        view.layer.addSublayer(layer)
        return layer
    }
    
    /// 4.根据view数量进行平均分布局 subViews:需要布局的子View数组,fatherView:添加子View的父View，height:传nil时和父View高度相同
    func viewWithLayoutEqualSubViews(_ subViews:Array<UIView>,fatherView:UIView,width:CGFloat?,height:CGFloat?){
        fatherView.layoutIfNeeded()
        let count = subViews.count
        let subHeight = height ?? fatherView.bounds.height
        let subWidth = width ?? subHeight
        let onceWidth = fatherView.bounds.width / CGFloat(count)
        let spacing = (onceWidth - subWidth) / 2
        
        guard count > 0 else{return}
        
        for view in subViews{
            fatherView.addSubview(view)
        }
        
        for i in 1...count{
            let tag = i - 1
            subViews[tag].frame = CGRect(x: (CGFloat(tag) * onceWidth) + spacing, y: 0, width: subWidth, height: subHeight)
        }
    }
    
    /// 5.创建单击消失的背景Btn
    func viewWithBlackBtnToBackground(_ targetView:UIView?,bgColor:UIColor?,allowClick:Bool = true) -> UIButton{
        let btn = UIButton()
        
        if targetView == nil {
            let window = UIApplication.shared.keyWindow
            window?.addSubview(btn)
            btn.frame = window?.frame ?? CGRect(x: 0, y: 0, width: FScreenW, height: FScreenH)
        }else{
            targetView!.addSubview(btn)
            btn.frame = targetView!.bounds
        }
        
        btn.backgroundColor = colorWith(r: 0, g: 0, b: 0, a: 0.3)
        btn.alpha = 0
        
        if bgColor != nil {
            btn.backgroundColor = bgColor
        }
        
        if allowClick{
            btn.addTarget(self, action: #selector(clickBlackBtnToBackground(sender:)), for: .touchUpInside)
        }
        
        UIView.animate(withDuration: 0.23) {
            btn.alpha = 1
        }
        
        return btn
    }
    /// 点击消失的背景Btn
    @objc private func clickBlackBtnToBackground(sender:UIButton){
        UIView.animate(withDuration: 0.23, animations: {
            sender.alpha = 0
            self.btnWillCancelBlock?()
        }) { (Bool) in
            sender.removeFromSuperview()
            self.btnDidCancelBlock?()
        }
    }
    
}


//MARK:- Action   ----------------------------------------------------------------------
extension FDMQuick {
    
    /*==================
     1.为view添加拖拽手势(使用init创建,shared只能创建一个)
     2.为view添加底部弹出提示框(使用init创建,shared只能创建一个)
     3.手动关闭提示框
    ==================*/
    
    /// 1.为view添加拖拽手势(使用init创建,share只能创建一个) -isExceed:是否允许view超出m屏幕边界,默认为否
    func addDragPanGesture(recognizer:UIPanGestureRecognizer,view:UIView,isExceed:Bool = false){
        if recognizer.state == UIGestureRecognizer.State.began {
            centerPoint = view.center
            pointView = recognizer.translation(in: view)
        }else if recognizer.state == UIGestureRecognizer.State.changed{
            let point = recognizer.translation(in: view)
            let pointX = point.x - pointView!.x
            let pointY = point.y - pointView!.y
            var x = pointX + centerPoint!.x
            var y = pointY + centerPoint!.y
            
            if !isExceed {
                //left
                if x - view.bounds.width/2 <= 0 {
                    x = view.bounds.width/2
                }
                //right
                if x + view.bounds.width/2 >= UIScreen.main.bounds.width{
                    x = UIScreen.main.bounds.width - view.bounds.width/2
                }
                //top
                if y - view.bounds.height/2 <= 0 {
                    y = view.bounds.height/2
                }
                //bottom
                if y + view.bounds.height/2 >= UIScreen.main.bounds.height{
                    y = UIScreen.main.bounds.height - view.bounds.height/2
                }
            }
            view.center = CGPoint(x: x, y: y)
        }
    }
    
    /// 2.为view添加底部弹出类似分享的提示框(使用init创建,share只能创建一个) -tipSubView:子控件 -tipSuperView:父控件 如果tipSuperView有值，请不要在touchBegan中测试该控件(会重复调用touchBegan方法) 如果为nil，则默认将提示框添加到window上
    func addPresentTipsView(height:CGFloat ,tipSubView:UIView? ,tipSuperView:UIView? = nil){
        bgTipsView = UIView()
        bgTipsView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        bgTipsView!.frame = UIScreen.main.bounds
        
        if tipSuperView != nil {
            tipSuperView?.addSubview(bgTipsView!)
        }else{
            UIApplication.shared.keyWindow?.addSubview(bgTipsView!)
        }
        
        let tapBGTipsGesture = UITapGestureRecognizer(target: self, action: #selector(tipsViewToDismiss))
        tapBGTipsGesture.delegate = self
        bgTipsView?.addGestureRecognizer(tapBGTipsGesture)
        
        tipsView = UIView()
        tipsView!.backgroundColor = .white
        tipsView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: height)
        bgTipsView!.addSubview(tipsView!)
        
        viewRoundedCorners(view: tipsView!, corner: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), size: 13)
        
        if tipSubView != nil{
            tipsView?.backgroundColor = .clear
            tipsView?.addSubview(tipSubView!)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.bgTipsView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            self.tipsView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - height, width: UIScreen.main.bounds.width, height: height)
        }
    }
    
    /// 3.手动关闭提示框
    @objc func tipsViewToDismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.tipsView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
            self.bgTipsView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (Bool) in
            if Bool {
                self.tipsView?.removeFromSuperview()
                self.bgTipsView?.removeFromSuperview()
            }
        }
    }
}


// 弹出提示框的手势代理   ----------------------------------------------------------------------
extension FDMQuick:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: tipsView!))!{
            return false
        }else{
            return true
        }
    }
}


//MARK:- Color   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.RGB颜色快捷方式
     2.十六进制RGB
     3.随机色
     4.获取某个颜色的rgb值
     5.渐变色Layer
    ==================*/
    
    /// 1.RGB颜色快捷方式
    func colorWith(r:Float,g:Float,b:Float,a:CGFloat = 1) -> UIColor{
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: a)
    }
    
    /// 2.十六进制RGB
    func colorWithHex(hexString hex: String, alpha:CGFloat = 1) -> UIColor {
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
    func colorWithRandom() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 4.获取某个颜色的rgb值
    func colorWithRGB(color:UIColor) -> Array<CGFloat>{
        let rgbValue = String(format: "%@", color)
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
    
    /// 5.创建渐变色Layer  frame: layer大小  colors:渐变颜色数组  pointAry:[渐变起点，渐变终点] locations: 按照值颜色变化
    func colorWithGradationLayer(frame:CGRect,colors:Array<CGColor>,points:Array<CGPoint>,locations:Array<NSNumber>) -> CAGradientLayer{
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = points.first ?? CGPoint(x: 0,y: 0)
        gradientLayer.endPoint = points.last ?? CGPoint(x: 1,y: 1)
        gradientLayer.locations = locations
        
        return gradientLayer
    }
}


//MARK:- Image   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.通过颜色返回一张图片
     2.获取网络图片尺寸
     3.截取view作为图片
     4.生成二维码图片
     5.生成条形码图片
    ==================*/
    
    /// 1.通过颜色返回一张图片
    func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// 2.获取网络图片尺寸
    func imageSize(url: String?) -> CGSize {
        guard let urlStr = url else {
            return CGSize.zero
        }
        let tempUrl = URL(string: urlStr)
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
    
    /// 3.截取View作为图片 view:被设置的View包括子视图会转为图片
    func imageWithView(_ view:UIView) -> UIImage {
        let screenRect = view.bounds
        UIGraphicsBeginImageContext(screenRect.size)
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
    
    /// 4.生成二维码图片
    func imageWithQRCode(str:String) -> UIImage?{
        let context = CIContext()
        let data = str.data(using: .utf8)
        
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
    
    /// 5.生成条形码图片
    func imageWithBarCode(str:String) -> UIImage{
        // 注意生成条形码的编码方式
        let data = str.data(using: .utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(NSNumber(value: 0), forKey: "inputQuietSpace")
        let outputImage = filter?.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
        // 返回条形码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 10, y: 10))))
        return codeImage
    }
}


//MARK:- String   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.Base64 编解码
     2.MD5加密
     3.字符串尺寸
     4.复制字符串到剪切板
     5.从字符串URL中截取参数
     6.正则表达式查找字符
     7.检查字符串中是否包含emoji表情（部分）
    ==================*/
    
    /// 1. Base64 编解码 -string: 需要编解码的字符串 -encode: true:编码 false:解码 需要先将占位符换为=
    func stringWithBase64(string: String?, encode: Bool) -> String? {
        if encode { // 编码
            guard let codingData = string?.data(using: .utf8) else {
                return nil
            }
            return codingData.base64EncodedString()
        } else { // 解码
            guard let newStr = string else {
                return nil
            }
            guard let decryptionData = Data(base64Encoded: newStr, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return String.init(data: decryptionData, encoding: .utf8)
        }
    }
    
    /// 2.MD5加密 -string:字符 -lower:true为小写，false为大写  需#import<CommonCrypto/CommonDigest.h>和<CommonCrypto/CommonCryptor.h>
//    func stringWithMD5(string: String?, lower: Bool = true) -> String?{
//        guard let cStr = string?.cString(using: .utf8) else {
//            return nil
//        }
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
//        let md5String = NSMutableString();
//        for i in 0 ..< 16 {
//            if lower {
//                md5String.appendFormat("%02x", buffer[i])
//            } else {
//                md5String.appendFormat("%02X", buffer[i])
//            }
//        }
//        free(buffer)
//        return md5String as String
//    }
    
    /// 3.字符串尺寸
    func stringWithSize(str: String, font: UIFont, w: CGFloat, h: CGFloat = 0) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = str.boundingRect(with: CGSize(width: w, height: h), options: option, attributes: attributes, context: nil)
        
        return rect
    }
    
    /// 4.复制字符串到剪切板
    func stringWithCopyToClipboard(str:String) -> Bool{
        let pab = UIPasteboard.general
        pab.string = str
        
        if pab.string != nil{
            return true
        }else{
            return false
        }
    }
    
    /// 5.从字符串URL中截取参数
    func stringParamsWithURL(_ url:String) -> [String:String]?{
        guard let components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    /// 6.正则表达式查找字符 pattern:正则表达式 text:需要验证的字符串 返回ture:验证成功
    func stringWithRegularExpression(pattern:String,text:String) -> Bool{
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex?.matches(in: text, options: .reportProgress, range: NSRange(location: 0, length: text.count))
        
        if matches?.count != 0 {
            return true
        }else{
            return false
        }
    }
    
    /// 检查字符串中是否包含emoji表情（部分）
    func stringIsEmoji(_ str: String) -> Bool {
        let unicodeScalars = str.unicodeScalars
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF:  // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        
        return false
    }
}

//MARK:- Json   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.JsonString转Dictionary
     2.Dictionary转Json字符串
     3.JsonArray 转 DictionArray
     4.array 转 jsonString
    ==================*/
    
    /// 1.JsonString转为Dictionary<String,Any>
    func JSONStringChageDictionary(jsonString:String) -> Dictionary<String,Any>?{
        do {
        let dic = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
        
            return dic
        }catch{
            return ["FDMQuick解析失败":"JsonString转Dictionary【失败】"]
        }
    }
    
    /// 2.Dictionary<String,Any>转Json字符串
    func JSONStringFromDictionary(dictionary:NSDictionary) -> String{
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            return "FDMQuick解析失败,Dictionary<String,Any>转Json字符串【失败】"
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    /// 3.JsonArray 转 DictionArray
    func JSONArrayChageDictionArray(jsonString:String) -> NSArray {
        let jsonData:Data = jsonString.data(using: .utf8)!
         
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    /// 4.数组转json
    func JSONStringFromArray(array:NSArray) -> String {
         
        if (!JSONSerialization.isValidJSONObject(array)) {
            return "FDMQuick解析失败,数组转json【失败】"
        }
         
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
         
    }
}


//MARK:- Cache   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.缓存和documents文件大小总和
     2.documents文件大小
     3.缓存大小
     4.清理缓存
     5.清理documents文件
    ==================*/
    
    /// 1.缓存和documents文件大小总和
    func cacheAndDocumentsSize() -> String{
        let documentsFileSize = documentsSize()
        let cacheFileSize = cacheSize()
        return NSString(format: "%.2fMB", (documentsFileSize + cacheFileSize) / 1024.0 / 1024.0 ) as String
    }
    
    /// 2.documents文件大小
    func documentsSize() -> Float{
        // 路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        // 遍历出所有缓存文件加起来的大小
        func caculateDocuments() -> Float{
            var total: Float = 0
            if fileManager.fileExists(atPath: documentsPath!){
                let childrenPath = fileManager.subpaths(atPath: documentsPath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = documentsPath!.appending("/").appending(path)
                        do{
                            let attr:NSDictionary = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                            let fileSize = attr["NSFileSize"] as? Float
                            total += fileSize ?? 0
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            // 缓存文件大小
            return total
        }
        // 调用函数
        let totalDocuments = caculateDocuments()
        return totalDocuments
    }
    
    /// 3.缓存大小
    func cacheSize() -> Float{
        // 路径
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        // 遍历出所有缓存文件加起来的大小
        func caculateCache() -> Float{
            var total: Float = 0
            if fileManager.fileExists(atPath: basePath!){
                let childrenPath = fileManager.subpaths(atPath: basePath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = basePath!.appending("/").appending(path)
                        do{
                            let attr:NSDictionary = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                            let fileSize = attr["NSFileSize"] as? Float
                            total += fileSize ?? 0
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            // 缓存文件大小
            return total
        }
        // 调用函数
        let totalCache = caculateCache()
        return totalCache
    }
    
    /// 4.清理缓存  -return是否清理成功
    func cacheWithClear() -> Bool {
        var result = true
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            // 拼接文件路径
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                // 循环删除
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    // 删除失败
                    result = false
                }
            }
        }
        return result
    }
    
    /// 5.清理documents文件 -return是否清理成功
    func documentsWithClear() -> Bool {
        var result = true
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: documentsPath!)
        // 遍历删除
        for file in fileArr! {
            // 拼接文件路径
            let path = documentsPath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                // 循环删除
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    // 删除失败
                    result = false
                }
            }
        }
        return result
    }
}

//MARK: Other   ----------------------------------------------------------------------
extension FDMQuick{
    
    /*==================
     1.普通打印
     2.网络请求打印
     4.快捷弹窗提示 提示
     5.快捷弹窗提示 提示
     6.快捷弹窗提示 好
     7.快捷弹窗提示 确认-取消
     8.获取手机型号
     9.获取状态栏高度
     10.获取tabBar高度
     11.获取底部安全区高度
     12.获取某一天是周几
     13.将周几转为汉字
     14.获取当前 秒级 时间戳 - 10位(带小数点)
     15.获取日期 秒级 时间戳 - 10位(带小数点)
     16.获取当前 毫秒级 时间戳 - 13位(带小数点)
     17.获取日期 毫秒级 时间戳 - 13位(带小数点)
     18.iOS13获取deviceToken
     19.X - N 的随机数
    ==================*/
    
    /// 1.普通打印
    class func Log<T,K>(title: T, message: K, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("================================\n  标题:【\(title)】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  信息: 【\(message)】\n================================")
        #endif
    }
    
    /// 2.网络请求打印
    class func LogWithNetwork<T,K>(title: T, message : K, isSuccess : Bool , file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
        if isSuccess {
            print("================================\n  标题:【\(title) 请求成功】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  信息: 【\(message)】\n================================")
        }else{
            print("================================\n  标题:【\(title) 请求失败】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  错误信息: 【\(message)】\n================================")
        }
        
        #endif
    }
    
    /// 4.快捷弹窗提示 提示
    class func showTip(message:String, viewController:UIViewController) -> Void {
        show(title: "提示", message: message, viewController: viewController)
    }
    
    /// 5.快捷弹窗提示 提示
    class func showTip(message:String, viewController:UIViewController, okAction: @escaping (UIAlertAction) -> Swift.Void) -> Void {
        show(title: "提示", message: message, viewController: viewController, okAction: okAction)
    }
    
    /// 6.快捷弹窗提示 好
    class func show(title:String, message:String, viewController:UIViewController, okAction: ((UIAlertAction) -> Swift.Void)? = nil) -> Void {
        let av = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ac = UIAlertAction.init(title: "好", style: UIAlertAction.Style.cancel, handler: okAction)
        av.addAction(ac)
        viewController.present(av, animated: true, completion: nil)
    }
    
    /// 7.快捷弹窗提示 确认-取消
    class func showCancelOrOk(title:String? = nil, message:String? = nil, viewController:UIViewController, okAction: ((UIAlertAction) -> Swift.Void)? = nil ,cancelAction: ((UIAlertAction) -> Swift.Void)? = nil) -> Void {
        let av = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ac1 = UIAlertAction.init(title: "取消", style: .cancel, handler: cancelAction)
        let ac = UIAlertAction.init(title: "确认", style: .destructive, handler: okAction)
        av.addAction(ac)
        av.addAction(ac1)
        viewController.present(av, animated: true, completion: nil)
    }
    
    /// 8.获取手机型号
    class func getPhoneModel() -> PhoneModel{
        if FScreenW == 320.0 && FScreenH == 480.0{    // iPhone 4_4s_5_5s_5c
            return.iPhone4_4s_5_5s_5c
        }else if FScreenW == 375.0 && FScreenH == 667.0{    // iPhone 6_6s_7_8
            return.iPhone6_6s_7_8
        }else if FScreenW == 414.0 && FScreenH == 736.0{    // iPhone 6P_6sP_7P_8P
            return.iPhone6P_6sP_7P_8p
        }else if FScreenW == 375.0 && FScreenH == 812.0 {    // iPhone X
            return.iPhone_X
        }else if FScreenW == 414.0 && FScreenH == 896.0{    // iPhone XR
            return.iPhone_XR
        }else if FScreenW == 375.0 && FScreenH == 812.0{    // iPhone XS
            return.iPhone_XS
        }else if FScreenW == 414.0 && FScreenH == 896.0{    // iPhone XS Max
            return.iPhone_XS_Max
        }else{  //其他全面屏手机
            return.otherFullScreen
        }
    }
    
    /// 9.获取状态栏高度
    class func screenWithStatusHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 44.0
        }else{
            return 20.0
        }
    }
    
    /// 10.获取tabBar高度
    class func screenWithTabBarHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 49.0 + 34.0
        }else{
            return 49.0
        }
    }
    
    /// 11.获取底部安全区高度
    class func screenWithBottomSafeHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 34.0
        }else{
            return 0.0
        }
    }
    
    /// 12.获取某一天是周几 return: [1 - 7]
    class func dayOfWeek(date:Date) -> Int {
        let interval = date.timeIntervalSince1970
        let days = Int(interval / 86400)

        return (days - 3) % 7
    }
    
    /// 13.将周几转为汉字 week:[1 - 7]
    class func weekWithChinese(week:Int) -> String{
        switch week {
            case 1:
                return "周一"
            case 2:
                return "周二"
            case 3:
                return "周三"
            case 4:
                return "周四"
            case 5:
                return "周五"
            case 6:
                return "周六"
            case 7:
                return "周日"
            default:
                return "请输入正确日期 1-7"
        }
    }
    
    /// 14.获取当前 秒级 时间戳 - 10位
    static func timeStamp() -> Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        return timeStamp
    }
    
    /// 15.获取日期 秒级 时间戳 - 10位
    static func timeStampByDate(_ date: Date) -> Double {
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        return timeStamp
    }
    
    /// 16.获取当前 毫秒级 时间戳 - 13位
    static func milliStamp() -> Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Double(millisecond)
    }
    
    /// 17.获取日期 毫秒级 时间戳 - 13位
    static func milliStampByDate(_ date: Date) -> Double {
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Double(millisecond)
    }
    
    /// 18.iOS13获取deviceToken [didRegisterForRemoteNotificationsWithDeviceToken]
    class func getDeviceTokenWithiOS13(deviceToken: Data) -> String{
        var tokenString = ""
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            tokenString += String(format: "%02x", item&0x000000FF)
        }
        
        return tokenString
    }
    
    /// 19.X - N 的随机数
    class func getArc4random(start:UInt32,end:UInt32) -> CGFloat{
        return CGFloat(arc4random() % (end - start) + start)
    }
}

