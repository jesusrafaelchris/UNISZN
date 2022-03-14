//
//  ZoomingLogic.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 20/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

//import UIKit
//
//class zoomingLogic {
//
//
//   func performZoomForStartingImageView(_ startingImage: UIImageView) {
//
//       self.startingImage = startingImage
//       self.startingImage?.isHidden = false
//       startingFrame = startingImage.superview?.convert(startingImage.frame, to: nil)
//
//       let zoomingImageView = UIImageView(frame: startingFrame!)
//       zoomingImageView.image = startingImage.image
//       zoomingImageView.isUserInteractionEnabled = true
//       zoomingImageView.contentMode = .scaleAspectFill
//       zoomingImageView.clipsToBounds = true
//       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomOut))
//       tapGestureRecognizer.numberOfTapsRequired = 1
//       zoomingImageView.addGestureRecognizer(tapGestureRecognizer)
//
//       if let keyWindow = UIApplication.shared.keyWindow {
//
//           blackBackgroundView = UIView(frame: keyWindow.frame)
//           blackBackgroundView?.alpha = 0
//           blackBackgroundView?.backgroundColor = .black
//
//           keyWindow.addSubview(blackBackgroundView!)
//           keyWindow.addSubview(zoomingImageView)
//
//           UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//           self.blackBackgroundView?.alpha = 1
//           self.view.alpha = 0
//
//               let height = (self.startingFrame!.height / self.startingFrame!.width) * keyWindow.frame.width
//
//           zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//
//           zoomingImageView.center = keyWindow.center
//
//           }, completion: nil)
//
//       }
//
//   }
//
//   @objc func zoomOut(tap: UITapGestureRecognizer) {
//       if let zoomOutImageView = tap.view {
//
//           zoomOutImageView.clipsToBounds = true
//           UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//               zoomOutImageView.frame = self.startingFrame!
//               self.blackBackgroundView?.alpha = 0
//               self.view.alpha = 1
//
//           }) { (completed: Bool) in
//               zoomOutImageView.removeFromSuperview()
//               self.startingImage?.isHidden = false
//
//           }
//       }
//   }
//
//
//}
