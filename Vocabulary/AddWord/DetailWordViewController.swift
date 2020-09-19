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
import PoingDesignSystem
import PoingVocaSubsystem
import SnapKit

class DetailWordViewController: UIViewController {
    
    enum State {
        case add
        case edit
    }
    
    enum Constant {
        enum Image {
            static let height: CGFloat = 166
        }
        enum Text {
            static let height: CGFloat = 56
        }
        enum Count {
            static let maxCount = 15
        }
    }
    
    // MARK: - Properties
    private let picker = UIImagePickerController()
    private let disposeBag = DisposeBag()
    private let viewModel: SelectViewModelType = SelectViewModel()
    
    var newGroup: Group?
    var currentState: State
    var getWord: Word?
    var getGroup: Group?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var naviView: SideNavigationView = {
        let view = SideNavigationView(leftImage: UIImage(named: "iconClose"), centerTitle: nil, rightImage: nil)
        view.backgroundColor = .white
        view.titleLabel.alpha = 0
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var wordImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icPicture")
        view.layer.cornerRadius = Constant.Image.height / 2
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "iconCamera"), for: .normal)
        button.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        return button
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadow(
            color: UIColor(red: 138.0 / 255.0, green: 149.0 / 255.0, blue: 158.0 / 255.0, alpha: 1),
            alpha: 0.2,
            x: 0,
            y: 10,
            blur: 60,
            spread: 0
        )
        view.layer.cornerRadius = 32
        view.clipsToBounds = false
        view.backgroundColor = .white
        return view
    }()
    lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [engTextField, korTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 26
        return stack
    }()
    lazy var engTextField: AddWordTextField = {
        let view = AddWordTextField()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 31
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.veryLightPink,
            .paragraphStyle: paragraphStyle,
            .kern: -0.5
        ]
        view.attributedPlaceholder = NSAttributedString(
            string: "영어 단어 입력",
            attributes: attributes
        )
        
        view.keyboardType = .asciiCapable
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return view
    }()
    lazy var korTextField: AddWordTextField = {
        let view = AddWordTextField()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 31
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.veryLightPink,
            .paragraphStyle: paragraphStyle,
            .kern: -0.5
        ]
        view.attributedPlaceholder = NSAttributedString(
            string: "단어 뜻 입력(한글)",
            attributes: attributes
        )
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    lazy var folderButton: SelectFolderButton = {
        let button = SelectFolderButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .grey244
        button.layer.cornerRadius = 20
        return button
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .veryLightPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.setTitle("단어 저장하기", for: .normal)
        button.setTitleColor(.brownGrey, for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmDidTap), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        return button
    }()
    
    init(image: UIImage) {
        self.currentState = .add
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
        self.wordImageView.image = image
        view.clipsToBounds = false
    }
    
    init(group: Group?, word: Word?) {
        self.currentState = .edit
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
        guard let getGroup = group else {
            return
        }
        self.folderButton.folderLabel.text = getGroup.title
        self.newGroup = getGroup
        self.getGroup = getGroup
        
        guard let getWord = word else {
            return
        }
        self.engTextField.text = getWord.english
        self.korTextField.text = getWord.korean
        self.getWord = getWord
        
        guard let getWordImage = getWord.image else {
            return
        }
        self.wordImageView.image = UIImage(data: getWordImage)
        
        view.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        registerForKeyboardNotifications()
        configureRx()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: .vocaDataChanged,
            object: nil
        )

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - View ✨
    func initView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubview(naviView)
        contentView.addSubview(containerView)
        containerView.addSubview(wordImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(folderButton)
        contentView.addSubview(cameraButton)
        contentView.addSubview(confirmButton)

        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }

        naviView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        wordImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.height.width.equalTo(166)
            make.top.equalTo(containerView.snp.top).offset(-55)
        }

        cameraButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(wordImageView.snp.trailing)
            make.bottom.equalTo(wordImageView.snp.bottom)
            make.width.height.equalTo(40)
        }

        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom).offset(69)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        textStack.snp.makeConstraints { (make) in
            make.top.equalTo(wordImageView.snp.bottom).offset(14)
            make.centerX.equalTo(containerView)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.bottom.equalTo(folderButton.snp.top).offset(-33)
        }

        folderButton.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.bottom.equalTo(containerView).offset(-16)
            make.height.equalTo(56)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(hasTopNotch ? 0 : -16 )
            make.centerX.equalTo(contentView)
        }
    }

    func configureRx() {
        
        viewModel.output.groups
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                
            }).disposed(by: disposeBag)
                
        engTextField.rx.controlEvent(.editingChanged)
            .subscribe { [weak self] (_) in
                guard let self = self else {
                    return
                }
                guard let engText = self.engTextField.text else {
                    return
                }
                guard let korText = self.korTextField.text else {
                    return
                }
                if engText.count > Constant.Count.maxCount {
                    self.engTextField.text = engText[0..<Constant.Count.maxCount]
                }
                
                self.confirmButton.isEnabled = (engText.count == 0 || korText.count == 0 ) ? false : true
                
                self.updateConfirmButton()
        }.disposed(by: disposeBag)
        
        korTextField.rx.controlEvent(.editingChanged)
            .subscribe { [weak self] (_) in
                guard let self = self else {
                    return
                }
                guard let engText = self.engTextField.text else {
                    return
                }
                guard let korText = self.korTextField.text else {
                    return
                }
                if korText.count > Constant.Count.maxCount {
                    self.engTextField.text = korText[0..<Constant.Count.maxCount]
                }
                
                self.confirmButton.isEnabled = (engText.count == 0 || korText.count == 0 ) ? false : true
                
                self.updateConfirmButton()
        }.disposed(by: disposeBag)
        
        folderButton.rx.tap.subscribe(onNext: {[weak self] (_) in
            let viewController = SelectVocaViewController()
            viewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.isHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            
            self?.confirmButton.isEnabled = (self?.engTextField.text?.count == 0 || self?.korTextField.text?.count == 0 ) ? false : true
            self?.updateConfirmButton()
            
            self?.present(navigationController, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    @objc func vocaDataChanged() {
        viewModel.input.fetchGroups()
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }

    
    @objc func addPicture(_ sender: Any) {
        
        self.picker.delegate = self
        let alert =  UIAlertController(title: "Add New Word", message: "단어에 넣을 사진을 찍어 주세요!", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func confirmDidTap(_ sender: Any) {
        guard let addGroup = self.newGroup else {
            let alert: UIAlertView = UIAlertView(title: nil, message: "단어장을 선택해 주세요!", delegate: nil, cancelButtonTitle: nil);
            
            alert.show()
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
            }
            return
        }
        
        switch currentState {
        case .add:
            let word = Word(
                korean: self.korTextField.text,
                english: self.engTextField.text,
                image: self.wordImageView.image?.jpegData(compressionQuality: 0.8),
                identifier: UUID(),
                order: Int16(addGroup.words.count)
            )
            
            VocaManager.shared.update(group: addGroup, addWords: [word]) { [weak self] in
                let alert: UIAlertView = UIAlertView(title: "단어 만들기 완료!", message: "단어장에 단어를 추가했어요!", delegate: nil, cancelButtonTitle: nil);
                
                alert.show()
                
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(withClickedButtonIndex: 0, animated: true)
                    
                    self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
        case .edit:
            guard let deleteGroup = self.getGroup, let deleteWord = self.getWord else {
                return
            }
            
            let word = Word(
                korean: self.korTextField.text,
                english: self.engTextField.text,
                image: self.wordImageView.image?.jpegData(compressionQuality: 0.8),
                identifier: UUID(),
                order: deleteWord.order
            )
            
            
            VocaManager.shared.update(deleteGroup: deleteGroup, addGroup: addGroup, deleteWords: [deleteWord], addWords: [word]) { [weak self ] in
                let alert: UIAlertView = UIAlertView(title: "단어 수정 완료!", message: "단어장의 단어를 수정했어요!", delegate: nil, cancelButtonTitle: nil);
                
                alert.show()
                
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(withClickedButtonIndex: 0, animated: true)
                    
                    self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @objc func tapLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateConfirmButton() {
        confirmButton.backgroundColor = confirmButton.isEnabled
            ? .brightSkyBlue
            : .veryLightPink
    }
}

extension DetailWordViewController: SelectVocaViewControllerDelegate {
    func selectVocaViewController(didTapGroup group: Group) {
        self.newGroup = group
        self.folderButton.folderLabel.text = group.title
    }
}

extension DetailWordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.wordImageView.image = possibleImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension DetailWordViewController: UITextFieldDelegate {
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
        
        guard let keyboardFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // 활성화된 텍스트 필드가 키보드에 의해 가려진다면 가려지지 않도록 스크롤한다.
        // 이 부분은 상황에 따라 불필요할 수 있다.
        var rect = self.view.frame
        rect.size.height -= keyboardFrame.height
        if rect.contains(korTextField.frame.origin) {
            scrollView.scrollRectToVisible(korTextField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        //self.view.frame.origin.y = 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

