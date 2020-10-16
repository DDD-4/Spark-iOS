# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!

def basicFrameworks
  pod 'SnapKit', '~> 5.0.0'
  pod 'SDWebImage', '~> 5.0'
end

target 'Vocabulary' do
  # Comment the next line if you don't want to use dynamic frameworks
  # Pods for Vocabulary
  basicFrameworks
  pod 'SwiftLint'
  pod 'Moya/RxSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "KeyboardObserver", '~> 2.1'
end

target 'VocaGame' do
  basicFrameworks
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'PoingVocaSubsystem' do
  pod 'Moya/RxSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'PoingDesignSystem' do
end
