
import UIKit

class ShakeableView: UIView {

    var shakeable = UIImageView()
    var leftArrow = UIImageView()
    var rightArrow = UIImageView()

    var movingLayer = CALayer()

    let nightColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)
    let dayColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = UIColor.clearColor()

        leftArrow = getTintedImage("LeftArrow")
        rightArrow = getTintedImage("RightArrow")
        shakeable = getTintedImage("Shake")

        let shakeView = UIView.init(frame: CGRect(
            x: 0, y: 0,
            width: shakeable.image!.size.width,
            height: leftArrow.image!.size.height + shakeable.image!.size.height))

        shakeable.frame = CGRectMake(0, leftArrow.image!.size.height, shakeable.image!.size.width, shakeable.image!.size.height)
        leftArrow.frame = CGRectMake(0, 0, leftArrow.image!.size.width, leftArrow.image!.size.height)
        rightArrow.frame = CGRectMake(shakeView.frame.width - rightArrow.image!.size.width, 0, rightArrow.image!.size.width, rightArrow.image!.size.height)
        shakeView.addSubview(leftArrow)
        shakeView.addSubview(rightArrow)
        movingLayer.contents = shakeable.image!.CGImage
        layer.addSublayer(movingLayer)
//        shakeView.addSubview(shakeable)


        self.addSubview(shakeView)
    }

    func getTintedImage(nameOfImage: String) -> UIImageView {
        let imageView = UIImageView ()
        if let image = UIImage(named: nameOfImage) {
            imageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        imageView.tintColor = dayColor
        return imageView
    }

}
