import Foundation
import UIKit

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension NSLayoutConstraint {
    
    static func activate(@AutoLayoutBuilder constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }
    
}
