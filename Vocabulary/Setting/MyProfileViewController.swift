//
//  MyProfileViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem
import PoingVocaSubsystem
import SnapKit
import KeyboardObserver
import RxSwift
import RxCocoa
import Photos
import SDWebImage

class MyProfileViewController: UIViewController {
    enum Constant {
        enum ProfileImage {
            static let topMargin: CGFloat = 32
            static let length: CGFloat = 166
        }
        enum Camera {
            static let length: CGFloat = 40
            static let image = UIImage(named: "icCamera")
        }
        enum Name {
            static let sideMargin: CGFloat = 32
            static let height: CGFloat = 56
        }
    }

    lazy var navView: SideNavigationView = {
        let view = SideNavigationView(
            leftImage: UIImage.init(named: "icArrow"),
            centerTitle: "프로필 수정",
            rightImage: UIImage(named: "btnCompleteDesabled")
        )
        view.leftSideButton.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        view.rightSideButton.addTarget(self, action: #selector(confirmDidTap(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constant.ProfileImage.length * 0.5
        view.clipsToBounds = true
        return view
    }()

    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constant.Camera.length * 0.5
        button.setImage(Constant.Camera.image, for: .normal)
        button.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()

    lazy var nameTextField: VDSTextField = {
        let text = VDSTextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = User.shared.userInfo?.name
        text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return text
    }()

    private let keyboard = KeyboardObserver()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private let disposeBag = DisposeBag()
    private var needAdjustScrollViewForTextFields = [UITextField]()
    private let picker = UIImagePickerController()

    private var selectedPhoto: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        observeKeyboard()
        configureProfileImage()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(gesture)

        needAdjustScrollViewForTextFields.append(nameTextField)
    }

    func configureProfileImage() {
        guard let photoURL = User.shared.userInfo?.photoUrl,
              photoURL.isEmpty == false else {
            profileImageView.image = UIImage(named: "yellowFace")
            return
        }
        profileImageView.sd_setImage(with: URL(string: photoURL))
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(navView)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(cameraButton)
        scrollView.addSubview(nameTextField)

        navView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalTo(view)
        }

        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint?.isActive = true

        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(Constant.ProfileImage.topMargin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(Constant.ProfileImage.length)
        }

        cameraButton.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(Constant.Camera.length)
        }

        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(27)
            make.leading.equalTo(view).offset(Constant.Name.sideMargin)
            make.trailing.equalTo(view).offset(-Constant.Name.sideMargin)
            make.height.equalTo(Constant.Name.height)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
        }
    }

    @objc func viewTapped(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }

    func observeKeyboard() {
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let bottom = keyboardFrameEnd.height - self.view.safeAreaInsets.bottom

                self.scrollView.contentInset.bottom = bottom
                self.scrollView.verticalScrollIndicatorInsets.bottom = bottom
                
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.adjustScrollViewOffset()
                }
            case .willHide:
                self.scrollView.contentInset.bottom = 0
                self.scrollView.verticalScrollIndicatorInsets.bottom = 0

                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }, completion: nil)
            default:
                break
            }
        }
    }

    /*
     needAdjustScrollViewForTextFields 에 추가된
     TextField에서 keyboard가 올라오면 그 뷰를 기준으로 offset 을 조정
     */
    private func adjustScrollViewOffset() {
        guard scrollView.contentSize.height > (scrollView.frame.size.height - scrollView.contentInset.bottom) else {
            return
        }

        for textField in needAdjustScrollViewForTextFields where textField.isFirstResponder {
            var offsetY: CGFloat = 0
            offsetY = textField.frame.maxY - (scrollView.frame.height - scrollView.contentInset.bottom)
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetY), animated: true)
            break
        }
    }

    private func fetchMyProfile(completion: @escaping (() -> Void)) {
        LoadingView.show()
        UserController.shared.getUserInfo()
            .subscribe(onNext: { (response) in
                LoadingView.hide()
                User.shared.userInfo = response
                completion()
            }, onError: { (error) in
                LoadingView.hide()
            })
            .disposed(by: disposeBag)
    }

    private func requestSaveMyProfile() {
        let imageData = selectedPhoto?.jpegData(compressionQuality: 0.8)
        LoadingView.show()
        UserController.shared.editUser(
            name: nameTextField.text ?? "",
            photo: imageData
        )
        .subscribe(onNext: { [weak self] (response) in
            LoadingView.hide()
            guard let self = self else { return }
            self.fetchMyProfile {
                let viewController = SuccessPopupViewController(
                    title: "프로필 수정 완료!",
                    message: "설정에서 확인할 수 있어요!") {
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(viewController, animated: true, completion: nil)
            }
        }, onError: { (error) in
            LoadingView.hide()
        })
        .disposed(by: disposeBag)
    }

    @objc func closeDidTap(_ sender: UIButton) {
        let viewController = PopupViewController(
            title: "여기서 그만할까요?",
            message: "입력한 정보는 모두 사라져요.",
            cancelMessege: "취소",
            confirmMessege: "그만할래요"
        ) { [weak self] (bool) in
            if bool {
                self?.dismiss(animated: true, completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func addPicture(_ sender: Any) {
        self.picker.delegate = self
        let alert =  UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (action) in
            self?.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func confirmDidTap(_ sender: UIButton) {
        requestSaveMyProfile()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.nameTextField.text == "" {
            self.navView.rightSideButton.setImage(UIImage(named: "btnCompleteDesabled"), for: .normal)
            self.navView.rightSideButton.isEnabled = false
        } else {
            self.navView.rightSideButton.setImage(UIImage(named: "iconCompleteDefault"), for: .normal)
            self.navView.rightSideButton.isEnabled = true
        }
    }
}

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary(){
        self.picker.delegate = self
        self.picker.sourceType = .photoLibrary
        self.picker.allowsEditing = true
        
        self.present(self.picker, animated: true)
    }

    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.picker.delegate = self
            self.picker.sourceType = .camera
            self.picker.allowsEditing = true
            
            self.present(self.picker, animated: true)
        } else {
            print("Camera not available")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = UIImagePickerController.InfoKey.editedImage
        
        if let possibleImage = info[image] as? UIImage{
            selectedPhoto = possibleImage
            profileImageView.image = possibleImage
            navView.rightSideButton.setImage(UIImage(named: "iconCompleteDefault"), for: .normal)
            navView.rightSideButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
