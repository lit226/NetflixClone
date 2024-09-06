import Foundation
import UIKit

@resultBuilder
struct AutoLayoutBuilder {

    // Add support for constraints
    static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        components.flatMap { $0 }
    }
    
    // Add support for single constraints
    static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [expression]
    }
    
    // Add support for array of constraints
    static func buildExpression(_ expression: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        expression
    }
    
    // Add support for optionals
    static func buildOptional(_ component: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        component ?? []
    }

    // Add support for conditional checks
    static func buildEither(first component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        component
    }
    
    // Add support for conditional checks
    static func buildEither(second component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        component
    }
    
    // Add support for loops
    static func buildArray(_ components: [[NSLayoutConstraint]]) -> [NSLayoutConstraint] {
        components.flatMap { $0 }
    }

    // Add support for availability checks
    static func buildLimitedAvailability(_ component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        component
    }
}
