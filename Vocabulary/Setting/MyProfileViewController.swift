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
        
        guard let photoURL = User.shared.userInfo?.photoUrl,
              photoURL.isEmpty == false else {
            view.image = UIImage(named: "yellowFace")
            return view
        }
        view.sd_setImage(with: URL(string: photoURL), completed: .none)
    
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

    private let originName = User.shared.userInfo?.name
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        observeKeyboard()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(gesture)

        needAdjustScrollViewForTextFields.append(nameTextField)
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

    @objc func closeDidTap(_ sender: UIButton) {
        
        let viewController = PopupViewController(titleMessege: "여기서 그만할까요?", descriptionMessege: "입력한 정보는 모두 사라져요.", cancelMessege: "취소", confirmMessege: "그만할래요")
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
        
        //navigationController?.popViewController(animated: true)
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
        
        guard let image = self.profileImageView.image else {
            let alert: UIAlertView = UIAlertView(title: nil, message: "사진을 선택해 주세요!", delegate: nil, cancelButtonTitle: nil);
            
            alert.show()
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
            }
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        UserController.shared.editUser(
            name: self.nameTextField.text ?? "",
            photo: data ).subscribe { [weak self] response in
                guard let self = self else { return }
                if response.element?.statusCode == 200 {
                    let viewController = SuccessPopupViewController(titleMessege: "프로필 수정 완료!", descriptionMessege: "설정에서 확인할 수 있어요!")
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: true, completion: nil)
                    
                    UserController.shared.getUserInfo().subscribe { response in
                        if !response.isCompleted {
                            User.shared.userInfo = response.element
                        }
                    }.disposed(by: self.disposeBag)
                    
                }else {
                    //error
                }
            }.disposed(by: disposeBag)
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

extension MyProfileViewController: PopupViewDelegate {
    func didCancelTap(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func didConfirmTap(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
            self.profileImageView.image = possibleImage
            self.navView.rightSideButton.setImage(UIImage(named: "iconCompleteDefault"), for: .normal)
            self.navView.rightSideButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
