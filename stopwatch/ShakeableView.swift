
import UIKit

class ShakeableView: UIView {

    var leftArrow = UIImageView()
    var rightArrow = UIImageView()
    var shakeable = UIImageView()
    let shakeAnimation = CABasicAnimation(keyPath: "position")


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init() {
        super.init(frame: CGRect (x: 0.0, y:0.0, width: 1.0, height: 1.0))

        leftArrow = getTintedImage("LeftArrow")
        rightArrow = getTintedImage("RightArrow")
        shakeable = getTintedImage("Shake")

        self.backgroundColor = UIColor.clearColor()
        let shakeView = UIView.init(frame: CGRect(
            x: 0, y: 0,
            width: shakeable.image!.size.width,
            height: leftArrow.image!.size.height + shakeable.image!.size.height))

        shakeable.frame = CGRectMake(-(shakeView.frame.width / 2), leftArrow.image!.size.height, shakeable.image!.size.width, shakeable.image!.size.height)
        leftArrow.frame = CGRectMake(-(shakeView.frame.width / 2), 0, leftArrow.image!.size.width, leftArrow.image!.size.height)
        rightArrow.frame = CGRectMake((shakeView.frame.width / 2) - rightArrow.image!.size.width, 0, rightArrow.image!.size.width, rightArrow.image!.size.height)
        shakeView.addSubview(leftArrow)
        shakeView.addSubview(rightArrow)
        shakeView.addSubview(shakeable)

        NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(ShakeableView.shakeOnce), userInfo: nil, repeats: true)

        self.addSubview(shakeView)
    }

    func shakeOnce() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(shakeable.center.x - 5, shakeable.center.y))
        shakeAnimation.toValue = NSValue(CGPoint: CGPointMake(shakeable.center.x + 5, shakeable.center.y))
        shakeable.layer.addAnimation(shakeAnimation, forKey: "position")
    }

    func getTintedImage(nameOfImage: String) -> UIImageView {
        let imageView = UIImageView ()
        if let image = UIImage(named: nameOfImage) {
            imageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        imageView.tintColor = dayColor
        return imageView
    }

    func hide() {
        fadeToOpacity(0)
    }

    func show() {
        fadeToOpacity(1)
    }

    func fadeToOpacity(opacity : Float) {
        animateLayer(layer, duration: 0.5, animation: { l in l.opacity = opacity }, properties: "opacity")
    }

    let nightColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)
    let dayColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    func setColorScheme(mode: ColorMode) {
        if(mode == ColorMode.day) {
            rightArrow.tintColor = dayColor
            leftArrow.tintColor = dayColor
            shakeable.tintColor = dayColor
        } else {
            rightArrow.tintColor = nightColor
            leftArrow.tintColor = nightColor
            shakeable.tintColor = nightColor
        }
    }

}
