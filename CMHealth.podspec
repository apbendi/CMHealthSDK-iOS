Pod::Spec.new do |s|
  s.name              = "CMHealth"
  s.version           = "0.3.1"
  s.summary           = "A HIPAA compliant data storage interface for ResearchKit, from CloudMine."
  s.description       = <<-DESC
                        CMHealth is the easiest way to add secure, HIPAA compliant cloud data storage
                        and user management to your ResearchKit clinical study iOS app.  Built and
                        backed by CloudMine and the CloudMine Connected Health Cloud.
                       DESC

  s.homepage          = "https://github.com/cloudmine/CMHealthSDK-iOS"
  s.license           = 'MIT'
  s.author            = { "CloudMine" => "support@cloudmineinc.com" }
  s.source            = { :git => "https://github.com/cloudmine/CMHealthSDK-iOS.git", :tag => s.version.to_s }

  s.platform          = :ios, '9.0'
  s.requires_arc      = true

  s.public_header_files = 'CMHealth/CMHealth.h'
  s.source_files         = 'Pod/Classes/**/*'

  s.resource_bundles  = {
    'CMHealth' => ['Pod/Assets/*']
  }

  s.dependency 'ResearchKit', '~> 1.3.1'
  s.dependency 'CareKit', '~> 1.0'
  s.dependency 'CloudMine', '~> 1.7'
  s.dependency 'TPKeyboardAvoiding', '~> 1.2'
end
