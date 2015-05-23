Pod::Spec.new do |s|
  s.name             = "Swallow"
  s.version          = "0.1.0"
  s.summary          = "Twitter API wrapper"
  s.description      = <<-DESC
                       Twitter API wrapper

                       * Thin wrapper.
                       * Awkward notifications.
                       DESC
  s.homepage         = "https://github.com/thedoritos/Swallow"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "thedoritos" => "info@thedoritos.net" }
  s.source           = { :git => "https://github.com/thedoritos/Swallow.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thedoritos'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Swallow/Classes/**/*'
  s.resource_bundles = {
    'Swallow' => ['Swallow/Assets/*.png']
  }

  s.public_header_files = 'Swallow/Classes/**/*.h'
  s.frameworks = 'Social'
end
