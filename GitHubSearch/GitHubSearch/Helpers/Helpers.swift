//
//  UsersVC.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    func showAlert(message : String, onOkAction: (()->())? = nil) {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                onOkAction?()
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        
    }
}
extension UIImageView {
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let activityView = UIActivityIndicatorView(style: .medium)
        self.addSubview(activityView)
        activityView.frame = self.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }

            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
extension UILabel{
    func loadPublicRepCount(fromURL urlString: String, completion: ((UILabel, UserDetailsModel) -> Void)?){
        
        APIClient.shared.fetchData(urlStr: urlString) { [weak self ](result) in
            switch result{
            case .failure :
                break
            case .success(let data) :
                do{
                    let usersDetails = try JSONDecoder().decode(UserDetailsModel.self, from: data)
                    if let _ = usersDetails.message{
                        self?.text = "Repo#: ..."
                    }
                    else if let _ = usersDetails.login{
                        if let count = usersDetails.publicRep{
                            self?.text = "Repo#: \(count)"
                        }
                        if let _label = self{
                            completion?(_label,usersDetails)
                        }
                    }
                    
                }
                catch{
                }
                
            }
        }
    }
     func colorString(text: String?, coloredText: String?, color: UIColor? = .blue) {

        let attributedString = NSMutableAttributedString(string: text!)
        let range = (text! as NSString).range(of: coloredText!)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color!],
                                 range: range)
        self.attributedText = attributedString
    }
}
extension DateFormatter {
    public static var ISODateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    public static var mediumFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
}

extension String {
    public func displayDate() -> String? {
        let date = DateFormatter.ISODateFormatter.date(from: self)
        if let _date = date{
            return DateFormatter.mediumFormatter.string(from: _date)
        }
        return nil
    }
    
}
