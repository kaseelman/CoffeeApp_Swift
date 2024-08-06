import SwiftUI

struct SVGIcon: View {
    let name: String
    
    var body: some View {
        if let image = UIImage(named: name) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Text(name)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}
