//
//  MainTabBarController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Tab bar protocol
 */
protocol TabBarProtocol {
    var controller: UIViewController {get}
    var image: UIImage? {get}
    var selectedImage: UIImage? {get}
    var title: String? {get}
}

class MainTabBarController: AbstractTabBarController {

    private enum Controllers: TabBarProtocol {

        /// Questionnaire.
        case questionnaire
        /// Outfit.
        case outfit
        /// Wardrobe
        case wardrobe

        static let allCases: [Controllers] = [
            .outfit,
            .wardrobe,
            .questionnaire,
        ]

        var controller: UIViewController {
            switch self {
            case .questionnaire:
                return QuestionnaireViewController()
            case .outfit:
                return OutfitViewController()
            case .wardrobe:
                return WardrobeViewController()
            }
        }

        var image: UIImage? {
            switch self {
            case .questionnaire:
                fallthrough
            case .outfit:
                fallthrough
            case .wardrobe:
                return UIImage()
            }
        }

        var selectedImage: UIImage? {
            switch self {
            case .questionnaire:
                fallthrough
            case .outfit:
                fallthrough
            case .wardrobe:
                return UIImage()
            }
        }

        var title: String? {
            switch self {
            case .questionnaire:
                return StringContainer[.questionnaire]
            case .outfit:
                return StringContainer[.outfit]
            case .wardrobe:
                return StringContainer[.wardrobe]
            }
        }
    }

    // MARK: - <Initialize>
    override func setupView() {
        super.setupView()

        tabBar.barTintColor = Palette[custom: .purple]
        tabBar.tintColor = Palette[custom: .appColor]
    }

    internal override func customInit() {
        super.customInit()

        var controllers: [UIViewController] = []
        for controller in Controllers.allCases {
            let navigationController = UINavigationController(rootViewController: controller.controller)
            navigationController.navigationBar.tintColor = Palette[custom: .appColor]
            navigationController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
            navigationController.tabBarItem.title = controller.title
            navigationController.tabBarItem.image = controller.image
            navigationController.tabBarItem.selectedImage = controller.selectedImage
            controllers.append(navigationController)
        }
        viewControllers = controllers
    }
}
