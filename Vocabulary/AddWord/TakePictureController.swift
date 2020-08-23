//
//  TakePcitureViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/08/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SnapKit
import RxCocoa
import RxSwift

class TakePictureViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    lazy var captureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = .black
        button.addTarget(self, action:#selector(capturePhoto) , for: .touchUpInside)
        return button
    }()
    
    lazy var screenView: ScreenView = {
        let view = ScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoLibraryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_photo_camera"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(photoLibraryButtonTapped), for: .touchUpInside)
        captureButton.layer.cornerRadius = captureButton.bounds.height/2
        return button
    }()
    
    lazy var switchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_camera_rear"), for: .normal)
        button.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let disposeBag = DisposeBag()
    var image = UIImage()
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    var photoOuput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTripleCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    var picker = UIImagePickerController()
    
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
        
        screenView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        configureLayout()
        bindFunction()
    }
    
    // MARK: - init
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(photoLibraryButton)
        view.addSubview(screenView)
        view.addSubview(captureButton)
        view.addSubview(switchButton)
        view.addSubview(cancelButton)
        
        screenView.snp.makeConstraints { (make) in
            make.height.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        captureButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.width.equalTo(44)
        }
        
        photoLibraryButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(captureButton)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(44)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    // MARK: - Bind 🏷
    func bindFunction() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

extension TakePictureViewController {
    @objc func photoLibraryButtonTapped(_ sender: UITapGestureRecognizer) {
        
        self.picker.delegate = self
        self.picker.sourceType = .photoLibrary
        self.picker.allowsEditing = true
        
        self.present(self.picker, animated: true)
    }
    
    @objc func switchCamera(_ sender: Any) {
        guard videoDeviceDiscoverySession.devices.count > 1 else {
            return
        }
        
        sessionQueue.async {
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            let isFront = currentPosition == .front
            let preferredPosition: AVCaptureDevice.Position = isFront ? .back :  .front
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice?
            
            newVideoDevice = devices.first(where: { device in
                return preferredPosition == device.position
            })
            
            if let newDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.videoDeviceInput)
                    
                    // add new device input
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(self.videoDeviceInput)
                    }
                    
                    self.captureSession.commitConfiguration()
                    
                    DispatchQueue.main.async {
                        self.updateSwitchCameraIcon(position: preferredPosition)
                    }
                } catch {
                    print("error occured \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    func updateSwitchCameraIcon(position: AVCaptureDevice.Position) {
        // TODO: Update ICNN
        
        switch position {
        case .front:
            let image = #imageLiteral(resourceName: "ic_camera_front")
            switchButton.setImage(image, for: .normal)
        case .back:
            let image = #imageLiteral(resourceName: "ic_camera_rear")
            switchButton.setImage(image, for: .normal)
        default: break
        }
    }
    
    @objc func capturePhoto(_ sender: UIButton) {
        // TODO: photoOutput의 capturePhoto 메소드
        // orientation
        // photoOutput
        
        let videoPreviewLayerOrientation = self.screenView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async { // captureSession에서 사진을 찍는 것을 요청하는 것이다.
            
            // 요청을 하는것
            // 미디어에서 들어온 데이터가 photoOutput이 되어 사진이 되서 바깥으로 나갈건데
            // 그 오리엔테이션을 설정을 해주는것
            let connectino = self.photoOuput.connection(with: .video)
            connectino?.videoOrientation = videoPreviewLayerOrientation!
            
            // 오리엔테이션이 완료되었으면 포토아웃풋한테 사진을 찍자고 알려주는것
            let setting = AVCapturePhotoSettings()
            self.photoOuput.capturePhoto(with: setting, delegate: self)
        }
    }
    
    func savePhotoLibrary(image: UIImage) {
        // TODO: capture한 이미지 포토라이브러리에 저장
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                // save
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (success, error) in
                    if let err = error {
                        print("\(error?.localizedDescription)" )
                    }
                    print("image saved? : \(success)")
                }
            } else {
                // request
                
                print("--> request auth again")
            }
        }
    }
}

extension TakePictureViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        // TODO: captureSession 구성하기
        // - presetSetting 하기
        // - beginConfiguration
        // - Add Video Input
        // - Add Photo Output
        // - commitConfiguration
        
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        //input device와 session연결하고, 작업이 다 끝난경우에는 session과 output device 를 연결하는 것이 중요하다.
        
        // add video input
        // 인풋인 경우 먼저 디바이스를 찾고 연결을 세션이랑 해 주어야한다.
        var defaultVideoDevice: AVCaptureDevice?
        guard let camera = videoDeviceDiscoverySession.devices.first else {
            captureSession.commitConfiguration()
            return
            
        }
        //실제 카메라를 가져와야지 캡쳐디바이스를 구성할 수 있기 때문이다.
        do {
            let deviceInput = try AVCaptureDeviceInput(device: camera) // 될수도 있고 안될수도 있기때문에 try를 해주는 것이 중요하다.
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
                self.videoDeviceInput = deviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch let error {
            captureSession.commitConfiguration()
            return
        }
        
        // add photo output
        photoOuput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil) // 포토아웃풋에 대해서 어떤 식으로 저장을 할지 정하는 것이 중요하다.
        
        if captureSession.canAddOutput(photoOuput) {
            captureSession.addOutput(photoOuput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        // TODO: session Start
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        // TODO: session Stop
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension TakePictureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // TODO: capturePhoto delegate method 구현
        // 오리엔테이션이 회전하는 일이 없도록 만든다.
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            
            self.present(AddWordViewController(image: image), animated: true, completion: nil)
        }
        
        self.savePhotoLibrary(image: image)
    }
}

extension TakePictureViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = UIImagePickerController.InfoKey.editedImage
        
        if let possibleImage = info[image] as? UIImage {
            self.image = possibleImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.present(AddWordViewController(image: self.image), animated: true, completion: nil)
        }
    }
}
