//  
// Copyright (c) 2018 Loverde Co.
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
 

import Foundation
import UIKit

#if os(iOS) || os(macOS)
public extension UIImage {
    //Extension Required by RoundedButton to create UIImage from UIColor
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    /** Cria uma cópia de uma imagem fazendo sobreposição de cor.*/
    func tintImage(color:UIColor) -> UIImage {
        
        let newImage = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        color.set()
        newImage.draw(in: CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        let finalImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return finalImage ?? self
    }
    
    ///Make transparent color of image - choose a color and range color
    func backgroundColorTransparent(initialColor: UIColor, finalColor: UIColor) -> UIImage? {

        let image = UIImage(data: self.jpegData(compressionQuality: 1.0)!)!
        let rawImageRef: CGImage = image.cgImage!
        
        //let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        let colorMasking: [CGFloat] = [finalColor.redValue, initialColor.redValue, finalColor.greenValue, initialColor.greenValue, finalColor.blueValue, initialColor.blueValue]
        UIGraphicsBeginImageContext(image.size);

        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0,y: image.size.height)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result

    }

    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func resizeImage(newWidth: CGFloat) -> UIImage {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    /// Verifica se a imagem instanciada é uma animação.
    /// - Returns: O retorno será 'true' para imagens animadas e 'false' para imagens normais.
    func isAnimated() -> Bool {
        if ((self.images?.count ?? 0) > 1) {
            return true
        }
        return false
    }
    
    
    /// Cria o `thumbnail` da imagem.
    /// - Parameter maxPixelSize: Máxima dimensão que o thumb deve ter.
    /// - Returns: Retorna uma nova instância cópia do objeto imagem original.
    func createThumbnail(_ maxPixelSize:UInt) -> UIImage {
        
        if self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        if let data = self.pngData() {
            let imageSource:CGImageSource = CGImageSourceCreateWithData(data as CFData, nil)!
            //
            var options: [NSString:Any] = Dictionary()
            options[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
            options[kCGImageSourceCreateThumbnailFromImageAlways] = true
            //
            if let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
                let finalImage = UIImage.init(cgImage: scaledImage)
                return finalImage
            }
        }
        
        return self
    }
    
    /// Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve conter canal alpha, que definirá a visibilidade final da imagem resultante.
    func maskWithAlphaImage(maskImage:UIImage) -> UIImage {
        
        if self.cgImage == nil || maskImage.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let filterName = "CIBlendWithAlphaMask"
        
        let inputImage = CIImage.init(cgImage: self.cgImage!)
        let inputMaskImage = CIImage.init(cgImage: maskImage.cgImage!)
        
        let context:CIContext = CIContext.init()
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(inputMaskImage, forKey: kCIInputMaskImageKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }

    /// SwifterSwift: Create a new image from a base 64 string.
    ///
    /// - Parameters:
    ///   - base64String: a base-64 `String`, representing the image
    ///   - scale: The scale factor to assume when interpreting the image data created from the base-64 string. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the `size` property.
    convenience init?(base64String: String, scale: CGFloat = 1.0) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data, scale: scale)
    }

    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
#endif
