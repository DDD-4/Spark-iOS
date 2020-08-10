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
  if #available(iOS 11.0, tvOS 11.0, *) {
    // with notch: 44.0 on iPhone X, XS, XS Max, XR.
    // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
    return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
  }
  return false
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
            color: UIColor(red: 1.0, green: 221.0 / 255.0, blue: 14.0 / 255.0, alpha: 0.5), alpha: 1, x: 0, y: 5, blur: 20, spread: 0)
        button.layer.masksToBounds = false
        return button
    }()

    lazy var gameFloatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnGame"), for: .normal)
        button.layer.shadow(
            color: UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 0.5), alpha: 1, x: 0, y: 5, blur: 20, spread: 0)
        button.layer.masksToBounds = false
        return button
    }()

    lazy var myVocaViewController = MyVocaViewController()
    lazy var vocaForAllViewController = VocaForAllViewController(groups: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureRx()
        
        // start pageViewController
        pageViewController.setViewControllers(
            [myVocaViewController],
            direction: .forward,
            animated: false,
            completion: nil
        )
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
                self?.present(viewController, animated: true, completion: nil)
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
        let myViewController = MyViewController()
        present(myViewController, animated: true, completion: nil)
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
