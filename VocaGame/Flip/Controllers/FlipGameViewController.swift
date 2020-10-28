//
//  ViewController.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import PoingDesignSystem
import SnapKit

public class FlipGameViewController: UIViewController {
    enum Constant {
        static let backgroundColor = #colorLiteral(red: 0.9567821622, green: 0.9569162726, blue: 0.9567400813, alpha: 1)
        static let navigationHeight: CGFloat = 44

        enum Guide {
            enum Tap {
                static let title = "카드를 터치해서 단어의 이미지 확인하기"
                static let image = UIImage(named: "GuideiconTouch")!
            }
            enum Swipe {
                static let title = "카드를 잡고 오른쪽으로 끌어서 다음 카드 보기"
                static let image = UIImage(named: "GuideiconSwipe")!
            }
        }
    }

    //MARK: - Properties
    var viewModelData = [CardsDataModel]()

    lazy var navigationView: ProgressBarNavigationView = {
        let view = ProgressBarNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeButton.addTarget(
            self,
            action: #selector(closeDidTap(_:)),
            for: .touchUpInside
        )
        return view
    }()

    lazy var stackContainer: StackContainerView = {
        let view = StackContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var flipGuideView: GuideView?

    //MARK: - Init

    public init(words: [Word]) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical

        if let wordCoreDataList = words as? [WordCoreData] {
            for word in wordCoreDataList {
                guard let imageData = word.image,
                      let uiimage = UIImage(data: imageData) else {
                    return
                }

                let cardDataModel = CardsDataModel(
                    text: word.english,
                    imageType: .uiimage(image: uiimage)
                )

                viewModelData.append(cardDataModel)
            }
        } else {
            for word in words {
                guard let photoString = word.photoUrl,
                      let photoURL = URL(string: photoString) else {
                    return
                }

                let cardDataModel = CardsDataModel(
                    text: word.english,
                    imageType: .photoURL(url: photoURL)
                )

                viewModelData.append(cardDataModel)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.configire(maxCount: viewModelData.count)
        stackContainer.configure(maxCount: viewModelData.count)
        configureLayout()
    }

    func configureLayout() {
        stackContainer.delegate = self

        view.backgroundColor = Constant.backgroundColor
        view.addSubview(navigationView)
        view.addSubview(stackContainer)

        navigationView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constant.navigationHeight)
        }

        stackContainer.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.width - 32)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }

        // TODO: datasource didset change
        stackContainer.dataSource = self

        configureGuideView()
    }

    private func configureGuideView() {
        guard GameGuideUtill.isNeedGuide == false, flipGuideView == nil else {
            return
        }

        let guideView = GuideView(
            image: Constant.Guide.Tap.image,
            title: Constant.Guide.Tap.title
        )
        guideView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(guideView)
        view.bringSubviewToFront(guideView)

        NSLayoutConstraint.activate([
            guideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: hasTopNotch ? 0 : -16),
            guideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            guideView.topAnchor.constraint(equalTo: stackContainer.topAnchor, constant: 257)
        ])

        flipGuideView = guideView
    }

    private func removeGuideView() {
        guard let guideView = flipGuideView else { return }
        GameGuideUtill.didShowGuide()
        guideView.removeFromSuperview()
        flipGuideView = nil
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension FlipGameViewController : FlipCardViewDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func flipCard(at index: Int) -> FlipCardView {
        let card = FlipCardView(index: index)
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
}

extension FlipGameViewController: StackContainerViewDelegate {
    func stackContainerViewFirstCardTap(_ view: StackContainerView) {
        guard let guideView = flipGuideView else { return }
        guideView.configure(
            image: Constant.Guide.Swipe.image,
            title: Constant.Guide.Swipe.title
        )
    }

    func stackContainerViewFirstCardSwipe(_ view: StackContainerView) {
        guard flipGuideView != nil else { return }
        removeGuideView()
    }

    func stackContainerView(
        _ view: StackContainerView,
        didCompleteCard: FlipCardView
    ) {
        let completeViewController = VocaGame.GameCompleteViewController()
        completeViewController.delegate = self
        present(completeViewController, animated: true, completion: nil)
    }

    func stackContainerView(
        _ view: StackContainerView,
        didEndDisplayCard: FlipCardView,
        endIndex index: Int
    ) {
        // index starts from 0.
        navigationView.setProgress(index: index + 1)
    }
}

extension FlipGameViewController: GameCompleteViewControllerDelegate {
    public func GameCompleteViewController(_ viewController: GameCompleteViewController, didTapClose button: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }

    public func GameCompleteViewController(_ viewController: GameCompleteViewController, didTapRetry button: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
