import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let iconSize: CGFloat = 150
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
        iconImageView.image = UIImage(named: "AppLogoPng") // Make sure this matches your app icon's name
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.center = view.center
        
        view.addSubview(iconImageView)
    }
}
