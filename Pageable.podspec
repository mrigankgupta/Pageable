#
# Be sure to run `pod lib lint Pageable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Pageable'
  s.version          = '0.1.0'
  s.summary          = 'Infinite scrolling(Pagination) done right'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A lot of the time, when we’re making calls to REST API, there’ll be a lot of results to return. For that reason, we paginate the results to make sure responses are easier to handle. and most of the times, this will be required for differnt REST API's with in the app.
Pageable provide support for incorprating pagination in easy way. With pageable, pagination logic gets seperate from Tableview or CollectionView controllers.
                       DESC

  s.homepage         = 'https://github.com/mrigankgupta/Pageable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrigankgupta' => 'mrigankgupta@gmail.com' }
  s.source           = { :git => 'https://github.com/mrigankgupta/Pageable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/@mrigankgupta'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.source_files = 'Pageable/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Pageable' => ['Pageable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'

end
