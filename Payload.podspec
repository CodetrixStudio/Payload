Pod::Spec.new do |s|
  s.name         = "Payload"
  s.version      = "0.1.0"
  s.summary      = "Handles Payload so you don't have to."
  s.description  = <<-DESC
  Awesome lib to remove boilerplate code.
                   DESC

  s.homepage     = "https://github.com/CodetrixStudio/Payload"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Parveen Khatkar" => "parveen@codetrixstudio.com" }
  s.social_media_url   = "http://twitter.com/CodetrixStudio"
  
  s.swift_version = "4.2"
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/CodetrixStudio/Payload.git", :tag => "#{s.version}" }

  s.source_files  = "Payload", "Payload/**/*.{swift}"
  s.exclude_files = "Payload/Exclude"

  # s.public_header_files = "Classes/**/*.h"
end
