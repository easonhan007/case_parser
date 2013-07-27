case_parser
===========

将中文用例转换成selenium webdriver代码。

使用方法

```ruby
ruby demo.rb baidu.txt > baidu.rb
ruby baidu.rb
```

中文用例如下:

```
  打开http://www.baidu.com
  在文本框(id: 'kw')中输入watir-webdriver
  点击百度一下按钮(id: 'su')
```

转换后效果:

```ruby
require 'selenium-webdriver'
@b = Selenium::WebDriver.for :chrome
@b.get('http://www.baidu.com')
@b.find_element(id: 'kw').send_keys('watir-webdriver')
@b.find_element(id: 'su').click
@b.quit
```




