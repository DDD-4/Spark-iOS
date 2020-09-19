//
//  HomeViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

var hasTopNotch: Bool {
    return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
}

var bottomSafeInset: CGFloat {
    UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
}

enum HomeTabType: String {
    case myvoca = "나의 단어장"
    case vocaforall = "모두의 단어장"
}
class HomeViewController: UIViewController {
    enum Constant {
        static let headerTitle: [HomeTabType] = [HomeTabType.myvoca, HomeTabType.vocaforall]
        enum Floating {
            static let height: CGFloat = 60
        }
    }

    var disposeBag = DisposeBag()
    var currentTabType: HomeTabType = .myvoca

    lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView(
            titles: Constant.headerTitle,
            activeTabType: currentTabType,
            delegate: self
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: .none
        )
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()

    lazy var addWordFloatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnAdd"), for: .normal)
        button.layer.shadow(
            color: .brightSkyBlue50,
            alpha: 1,
            x: 0,
            y: 5,
            blur: 20,
            spread: 0
        )
        button.layer.masksToBounds = false
        return button
    }()

    lazy var gameFloatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnGame"), for: .normal)
        button.layer.shadow(
            color: .greyblue50,
            alpha: 1,
            x: 0,
            y: 5,
            blur: 20,
            spread: 0
        )
        button.layer.masksToBounds = false
        return button
    }()

    lazy var myVocaViewController = MyVocaViewController(viewType: .myVoca)
    lazy var vocaForAllViewController = MyVocaViewController(viewType: .vocaForAll)

    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureLayout()
        configureRx()
        // start pageViewController
        pageViewController.setViewControllers(
            [myVocaViewController],
            direction: .forward,
            animated: false,
            completion: nil
        )


        #if DEBUG
        window = UIWindow(frame: CGRect(
                            x: view.frame.maxX - 100,
                            y: view.frame.minY + 100,
                            width: 100,
                            height: 30))
        window?.rootViewController = ModeConfigStateViewController()
        window?.makeKeyAndVisible()
        #endif
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(headerView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(addWordFloatingButton)
        view.addSubview(gameFloatingButton)

        pageViewController.didMove(toParent: self)

        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(72)
        }

        pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }

        addWordFloatingButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.width.equalTo(Constant.Floating.height)
        }

        gameFloatingButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.width.equalTo(Constant.Floating.height)
        }
    }

    func configureRx() {
        addWordFloatingButton.rx.tap
            .subscribe(onNext: { [weak self](_) in
                let viewController = TakePictureViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.isHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .coverVertical
                self?.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        gameFloatingButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                let viewController = GameViewController()
                self?.present(viewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

extension HomeViewController: HomeHeaderDelegate {
    func homeHeader(_ view: HomeHeaderView, selectedTab: HomeTabType) {
        headerView.configire(activeTabType: selectedTab)
        if selectedTab == .myvoca {
            pageViewController.setViewControllers([myVocaViewController], direction: .reverse, animated: true, completion: nil)
        } else {
            pageViewController.setViewControllers([vocaForAllViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    func homeHeader(_ view: HomeHeaderView, settingDidTap button: UIButton) {
        let myViewController = SettingViewController()
        let navigationController = UINavigationController(rootViewController: myViewController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true, completion: nil)
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let viewController = previousViewControllers.first else {
            return
        }

        if viewController == myVocaViewController {
            currentTabType = .vocaforall
        } else {
            currentTabType = .myvoca
        }

        headerView.configire(activeTabType: currentTabType)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        viewController == myVocaViewController ? vocaForAllViewController : myVocaViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        viewController == myVocaViewController ? vocaForAllViewController : myVocaViewController
    }
}
