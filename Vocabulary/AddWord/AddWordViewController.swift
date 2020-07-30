//
//  AddWordViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/07/29.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddWordViewController: UIViewController {

    // MARK: - Properties
    let picker = UIImagePickerController()
    let disposeBag = DisposeBag()

    lazy var addWordNaviView: AddWordNavigationView = {
        let view = AddWordNavigationView()
        //view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addWordButton: BaseButton = {
        let button = BaseButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.setTitle("만들기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [engTextField, korTextField, folderButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    lazy var engTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영어 단어를 입력해 보세요!"
        //textField.backgroundColor = .white
        return textField
    }()
    lazy var korTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영어 단어의 뜻을 입력해 보세요!"
        //textField.backgroundColor = .white
        return textField
    }()
    lazy var folderButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("폴더 선택", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    lazy var wordImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icPicture")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindFunction()
        registerForKeyboardNotifications()
    }
    
    // MARK: - View ✨
    func initView() {
        
        view.addSubview(addWordNaviView)
        view.addSubview(addWordButton)
        view.addSubview(textStack)
        view.addSubview(wordImageView)
        view.backgroundColor = .white
        
        addWordNaviView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view).offset(8)
            make.height.equalTo(50)
        }
        
        addWordButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(186)
            make.bottom.equalTo(view).offset(-8)
            make.centerX.equalTo(view)
        }
        
        wordImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.width.equalTo(240)
            make.top.equalTo(addWordNaviView.snp.bottom).offset(47)
        }
        
        textStack.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.bottom.equalTo(addWordButton.snp.top).offset(-20)
        }
    }
    
    // MARK: - Bind 🏷
    func bindFunction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPicture))
        self.wordImageView.addGestureRecognizer(tap)

        addWordNaviView.settingButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    @objc func addPicture(_ sender: Any) {
        
        self.picker.delegate = self
        
        let alert =  UIAlertController(title: "Add New Word", message: "단어에 넣을 사진을 찍어 주세요!", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension AddWordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.wordImageView.image = possibleImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddWordViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.engTextField.resignFirstResponder()
        self.korTextField.resignFirstResponder()
    }
    
    // 옵저버 등록
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 옵저버 등록 해제
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ note: NSNotification) {
        let height = self.view.frame.size.height
        if let keyboardFrame: NSValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -self.view.frame.origin.y - keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
