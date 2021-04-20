Pod::Spec.new do |s|
s.name         = "CGXPageHomeScrollViewOC"    #存储库名称
s.version      = "0.0.1"      #版本号，与tag值一致
s.summary      = "CGXPageHomeScrollViewOC是基于UICollectionView封装的库，分区圆角边框，瀑布流、标签流等主流APP分页列表滚动视图的库)"  #简介
s.description  = "(UICollectionView封装的库，分区圆角边框，瀑布流、标签流、不规则布局等主流APP分页列表滚动视图的库封装"  #描述
s.homepage     = "https://github.com/974794055/CGXPageHomeScrollView"      #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
s.author             = { "974794055" => "974794055@qq.com" }  #作者
s.platform     = :ios, "8.0"                  #支持的平台和版本号
s.source       = { :git => "https://github.com/974794055/CGXPageCollectionView-OC.git", :tag => s.version }         #存储库的git地址，以及tag值
s.requires_arc = true #是否支持ARC
s.frameworks = 'UIKit'

#需要托管的源代码路径
s.source_files = 'CGXPageHomeScrollViewOC/**/*.{h,m}'
#开源库头文件
s.public_header_files = 'CGXPageHomeScrollViewOC/**/*.{h,m}'

 s.subspec 'Custom' do |ss|
    ss.source_files = 'CGXPageHomeScrollViewOC/Custom/**/*.{h,m}'
  end
 s.subspec 'ContainerView' do |ss|
    ss.source_files = 'CGXPageHomeScrollViewOC/ContainerView/**/*.{h,m}'
    ss.dependency 'CGXPageHomeScrollViewOC/Custom'
  end
 s.subspec 'List' do |ss|
    ss.source_files = 'CGXPageHomeScrollViewOC/List/**/*.{h,m}'
    ss.dependency 'CGXPageHomeScrollViewOC/ContainerView'
    ss.dependency 'CGXPageHomeScrollViewOC/Custom'
  end
 
end



