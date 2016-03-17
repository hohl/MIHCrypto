Pod::Spec.new do |s|
  s.name         = "MIHCrypto"
  s.version      = "0.4.0"
  s.license      = 'MIT'
  s.summary      = "OpenSSL wrapper for Objective-C"
  s.description  = "MIHCrypto provides an object-oriented cryptography framework based on libCrypto 
                    by OpenSSL. Supports RSA, DES, AES, ECC (Elliptic Curve Cryptography) and more."
  s.homepage     = "https://github.com/hohl/MIHCrypto"
  s.authors       =  {'Michael Hohl' => 'me@michaelhohl.net'}
  s.source       = { :git => "https://github.com/hohl/MIHCrypto.git", :tag => "#{s.version}" }
  
  s.ios.platform          = :ios, '8.0'
  s.ios.deployment_target = '6.0'
  s.osx.platform          = :osx, '10.10'
  s.osx.deployment_target = '10.8'

  s.requires_arc = true

  s.subspec 'Core' do |core|
    core.source_files = 'MIHCrypto/{Utils,Core}/*.{h,m,c}'
    core.dependency 'OpenSSL-Universal', '~> 1.0.1.18'
  end

  s.subspec 'Mathematics' do |ss|
    ss.source_files = 'MIHCrypto/Mathematics/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end

  s.subspec 'AES' do |ss|
    ss.source_files = 'MIHCrypto/AES/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end
  
  s.subspec 'DES' do |ss|
    ss.source_files = 'MIHCrypto/DES/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end

  s.subspec 'MD5' do |ss|
    ss.source_files = 'MIHCrypto/MD5/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end

  s.subspec 'RSA' do |ss|
    ss.source_files = 'MIHCrypto/RSA/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end
  
  s.subspec 'SHA' do |ss|
    ss.source_files = 'MIHCrypto/SHA/*.{h,m,c}'
    ss.dependency 'MIHCrypto/Core'
  end
end
