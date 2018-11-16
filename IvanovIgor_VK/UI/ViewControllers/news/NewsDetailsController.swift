import UIKit

class NewsDetailsController: UIViewController {
    @IBOutlet weak var prototypeImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    var swipeAnimator: UIViewPropertyAnimator?
    var constainerContentSize: CGFloat!
    
    var news: News!
    var images: [UIImageView] = []
    var currNumTouch = 0
    var maxTouches = 0
    var prevTouch: CGPoint!
    var isNewSwipe = true
    let standardItemScale: CGFloat = 0.6
    
    override func viewDidLoad() {
        let swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        imageContainerView.addGestureRecognizer(swipeRecognizer)
        
        for (idx, image) in news.images!.enumerated() {
            let newImageView = UIImageView(image: image)
            let dx = prototypeImageView.frame.size.width * CGFloat(idx) + imageContainerView.frame.width/2 - prototypeImageView.frame.size.width/2
            newImageView.frame = CGRect(x: dx, y: prototypeImageView.frame.origin.y, width: prototypeImageView.frame.width, height: prototypeImageView.frame.height)
            newImageView.contentMode = .scaleToFill
            images.append(newImageView)
            imageContainerView.addSubview(newImageView)
        }
        maxTouches = news.images?.count ?? 0
        constainerContentSize = prototypeImageView.frame.width
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        swipeAnimator?.stopAnimation(true)
        imageContainerView.removeFromSuperview()
    }
    
    func initSwipeAnimator(dx: CGFloat, sign: CGFloat){

        swipeAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5, animations: {
            self.images.forEach({ image in
                
                let maxDistance:CGFloat = 100
                let distance = min(abs(self.imageContainerView.frame.midX - abs(image.frame.midX + sign * self.constainerContentSize)), maxDistance)
                let ratio = (maxDistance - distance)/maxDistance
                let scale = ratio * (1 - self.standardItemScale) + self.standardItemScale

                image.transform = CGAffineTransform(translationX:dx , y: 0).concatenating(CGAffineTransform(scaleX: 1, y: scale))
                image.alpha = scale
            })
        })
        swipeAnimator?.startAnimation()
        swipeAnimator?.pauseAnimation()
    }
    
    
    @objc func didSwipe(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
            case .changed:
                let currTouch = recognizer.translation(in: self.imageContainerView)
           
                swipeAnimator?.fractionComplete =  -1 * (currTouch.x / 500)
                
                if isNewSwipe {
                    if prevTouch == nil {
                        prevTouch = currTouch
                        return
                    }
                    if prevTouch.x > currTouch.x {
                        guard currNumTouch < maxTouches - 1 else {return}
                        currNumTouch += 1
                        isNewSwipe = false
                        initSwipeAnimator(dx: -(self.constainerContentSize * CGFloat(self.currNumTouch)), sign: -1)
                    }
                    if prevTouch.x < currTouch.x
                    {
                        guard currNumTouch > 0 else {return}
                        currNumTouch -= 1
                        isNewSwipe = false
                        initSwipeAnimator(dx: -(self.constainerContentSize * CGFloat(self.currNumTouch)), sign: 1)
                    }
                }
            case .ended:
                prevTouch = nil
                isNewSwipe = true
                swipeAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)

            
            default: return
            
        }
    }
    
}
