import UIKit

public extension UIPageControl {

    func custom(colorNormal:UIColor, colorActive:UIColor, borderColor:UIColor, borderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            dotView.backgroundColor = self.currentPage == pageIndex ? colorActive : colorNormal
            dotView.layer.cornerRadius = dotView.frame.size.height / 2
            dotView.layer.borderColor = borderColor.cgColor
            dotView.layer.borderWidth = borderWidth
        }
    }

}
