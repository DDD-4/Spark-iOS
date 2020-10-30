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
        button.setImage(UIImage(named: "btnPhoto"), for: .normal)
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
        button.setImage(UIImage(named: "icCamera"), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    lazy var switchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_camera_rear"), for: .normal)
        button.tintColor = .midnight
        return button
    }()
    lazy var cancelButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnClose"), for: .normal)
        return button
    }()
    
    let disposeBag = DisposeBag()

    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput?
    let photoOuput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTripleCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)

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

        configureLayout()
        bindFunction()
        checkCameraPermission()
        checkPhotoPermission()
    }

    func startCameraSession() {
        screenView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
    }

    func requestLatestAlbumPhoto() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: fetchOptions)

        cameraRoll.enumerateObjects { [weak self] (collection, index, object) in
            guard let self = self else { return }
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
            if let latestPhoto = photoInAlbum.lastObject {
                self.updateLatestPhotoButton(photoInfo: latestPhoto)
            }
        }

    }

    func updateLatestPhotoButton(photoInfo: PHAsset) {
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        imageManager.requestImage(
            for: photoInfo,
            targetSize: CGSize(width: 40, height: 40),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.photoLibraryButton.setImage(image, for: .normal)
                }
            })
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(hasTopNotch ? 0 : -16)
            make.height.width.equalTo(80)
        }
        
        photoLibraryButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(captureButton.snp.centerY)
            make.width.height.equalTo(48)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(captureButton.snp.centerY)
            make.width.height.equalTo(60)
        }
    }
    
    // MARK: - Bind 🏷
    func bindFunction() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)

        photoLibraryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                pickerController.allowsEditing = true
                self.present(pickerController, animated: true)
            }).disposed(by: disposeBag)

        switchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.switchCamera()
            }).disposed(by: disposeBag)

        captureButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.capturePhoto()
            }).disposed(by: disposeBag)
    }

    func checkCameraPermission() {
        let cameraMediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: cameraMediaType)

        switch status {
        case .notDetermined:
          AVCaptureDevice.requestAccess(for: .video) { (_) in
            self.checkCameraPermission()
          }
        case .restricted, .denied:
            UIAlertController().presentShowAlert(
                title: "카메라 권한 허용 요청",
                message: "카메라로 찍은 사진을 단어장에 저장하기 위해서 카메라 권한이 필요합니다.",
                leftButtonTitle: "취소",
                rightButtonTitle: "설정으로"
            ) { (index) in
                if index == 0 {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                      return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                      UIApplication.shared.open(settingsUrl, completionHandler: { _ in self.checkCameraPermission()})
                    }
                }
            }
        case .authorized:
          self.startCameraSession()
        @unknown default:
          break
        }
    }

    func checkPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.global().async {
                self.requestLatestAlbumPhoto()
            }
        case .denied, .restricted, .limited :
            UIAlertController().presentShowAlert(
                title: "사진 권한 허용 요청",
                message: "단어장에 사진을 저장하기 위해서 사진 권한이 필요합니다",
                leftButtonTitle: "취소",
                rightButtonTitle: "설정으로"
            ) { (index) in
                if index == 0 {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                      return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                      UIApplication.shared.open(settingsUrl, completionHandler: { _ in self.checkPhotoPermission()})
                    }
                }
            }
        case .notDetermined:
          PHPhotoLibrary.requestAuthorization { (_) in
            self.checkPhotoPermission()
          }
        @unknown default:
          break
        }
    }
}

extension TakePictureViewController {
    func switchCamera() {
        guard videoDeviceDiscoverySession.devices.count > 1,
              let videoDeviceInput = videoDeviceInput else {
            return
        }
        
        sessionQueue.async {
            let currentVideoDevice = videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            let isFront = currentPosition == .front
            let preferredPosition: AVCaptureDevice.Position = isFront ? .back : .front
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice?
            
            newVideoDevice = devices.first(where: { device in
                return preferredPosition == device.position
            })
            
            if let newDevice = newVideoDevice {
                do {
                    let newDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(videoDeviceInput)
                    
                    // add new device input
                    if self.captureSession.canAddInput(newDeviceInput) {
                        self.captureSession.addInput(newDeviceInput)
                        self.videoDeviceInput = newDeviceInput
                    } else {
                        self.captureSession.addInput(videoDeviceInput)
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
    
    func capturePhoto() {
        // TODO: photoOutput의 capturePhoto 메소드
        // orientation
        // photoOutput
        
        let videoPreviewLayerOrientation = self.screenView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async { // captureSession에서 사진을 찍는 것을 요청하는 것이다.
            
            // 요청을 하는것
            // 미디어에서 들어온 데이터가 photoOutput이 되어 사진이 되서 바깥으로 나갈건데
            // 그 오리엔테이션을 설정을 해주는것
            let connection = self.photoOuput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            
            // 오리엔테이션이 완료되었으면 포토아웃풋한테 사진을 찍자고 알려주는것
            let setting = AVCapturePhotoSettings()
            self.photoOuput.capturePhoto(with: setting, delegate: self)

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
        } catch _ {
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
    
    func cropCameraImage(_ original: UIImage, previewLayer: AVCaptureVideoPreviewLayer) -> UIImage? {
        
        var image = UIImage()
        
        let previewImageLayerBounds = previewLayer.bounds
        
        let originalWidth = original.size.width
        let originalHeight = original.size.height
        
        let A = previewImageLayerBounds.origin
        let B = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.origin.y)
        let D = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.size.height)
        
        let a = previewLayer.captureDevicePointConverted(fromLayerPoint: A)
        let b = previewLayer.captureDevicePointConverted(fromLayerPoint: B)
        let d = previewLayer.captureDevicePointConverted(fromLayerPoint: D)
        
        let posX = floor(b.x * originalHeight)
        let posY = floor(b.y * originalWidth)
        
        let width: CGFloat = d.x * originalHeight - b.x * originalHeight
        let height: CGFloat = a.y * originalWidth - b.y * originalWidth
        
        let cropRect = CGRect(x: posX, y: posY, width: width, height: height)
        
        if let imageRef = original.cgImage?.cropping(to: cropRect) {
            image = UIImage(cgImage: imageRef, scale: original.scale, orientation: original.imageOrientation)
        }
        
        return image
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
        
        let myImage = cropCameraImage(image, previewLayer: self.screenView.videoPreviewLayer)!

        let rootViewController = DetailWordViewController(image: myImage)
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .coverVertical
        DispatchQueue.main.async {
            self.present(navController, animated: true, completion: nil)
        }
    }
}

extension TakePictureViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = UIImagePickerController.InfoKey.editedImage
        
        guard let possibleImage = info[image] as? UIImage else {
            return
        }

        DispatchQueue.main.async {
            picker.dismiss(animated: true) {
                let rootViewController = DetailWordViewController(image: possibleImage)

                let navController = UINavigationController(rootViewController: rootViewController)
                navController.navigationBar.isHidden = true
                navController.modalPresentationStyle = .fullScreen
                navController.modalTransitionStyle = .coverVertical
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
}
