Pod::Spec.new do |s|
        s.name             = 'SJAlertView'
        s.version          = '0.0.2'
        s.summary          = 'SJAlertView'
        s.homepage         = 'https://github.com/king129/SJAlertView'
        s.license          = { :type => 'MIT', :file => 'LICENSE' }
        s.author           = { 'king129' => 'king129@vip.163.com' }
        s.source           = { :git => 'https://github.com/king129/SJAlertView.git', :tag => s.version.to_s }

        s.ios.deployment_target = '8.0'
        s.requires_arc = true
        s.source_files = 'SJAlertView/**/*.{h,m}'
        s.public_header_files = 'SJAlertView/SJAlertView.h'
        s.frameworks = 'UIKit'

end
