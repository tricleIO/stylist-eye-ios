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
                return #imageLiteral(resourceName: "questions_icon")
            case .outfit:
                return #imageLiteral(resourceName: "outfits_icon")
            case .wardrobe:
                return #imageLiteral(resourceName: "cloakroom_icon")
            }
        }

        var selectedImage: UIImage? {
            switch self {
            case .questionnaire:
                return #imageLiteral(resourceName: "questions_icon")
            case .outfit:
                return #imageLiteral(resourceName: "outfits_icon")
            case .wardrobe:
                return #imageLiteral(resourceName: "cloakroom_icon")
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
        tabBar.tintColor = Palette[custom: .title]
        tabBar.isTranslucent = false
        tabBarItem.setTitleTextAttributes([
            NSFontAttributeName: SystemFont[.description]
            ]
            , for: .normal)
        tabBarItem.setTitleTextAttributes([
            NSFontAttributeName: SystemFont[.title]
            ]
            , for: .selected)
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
