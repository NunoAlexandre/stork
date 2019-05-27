Pod::Spec.new do |s|
  s.name                  = "StorkEgg"
  s.module_name           = "Stork"
  s.version               = "0.2.1"
  s.summary               = "Delivering types from JSON like a Stork"
  s.homepage              = "https://github.com/NunoAlexandre/stork"
  s.license               = { :type => "BSD 3", :file => "LICENSE" }
  s.author                = { "NunoAlexandre" => "nunombalexandre at gmail dot com" }
  s.source                = { :git => "https://github.com/NunoAlexandre/stork.git", :tag => s.version  }
  s.source_files          = "Stork/Stork/Source/**/*"
  s.swift_version         = "5.0"
  s.ios.deployment_target = "9.0"
end
