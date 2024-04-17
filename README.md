# SBNavigationController

<p align="center">
    <a href="https://cocoapods.org/pods/SBNavigationController"><img src="https://img.shields.io/badge/Cocoapods-supported-brightgreen"></a> 
    <a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-supported-brightgreen"></a> 
    <a href="https://github.com/spirit-jsb/SBNavigationController"><img src="https://img.shields.io/github/v/release/spirit-jsb/SBNavigationController?display_name=tag"/></a>
    <a href="https://github.com/spirit-jsb/SBNavigationController"><img src="https://img.shields.io/cocoapods/p/ios"/></a>
    <a href="https://github.com/spirit-jsb/SBNavigationController/blob/master/LICENSE"><img src="https://img.shields.io/github/license/spirit-jsb/SBNavigationController"/></a>
</p>

## 视图结构
```
SBNavigationController
   ┌─SBContainerViewController
   │    ──SBContainerNavigationController
   │         ──firstViewController
   │
   └─SBContainerViewController
        ──SBContainerNavigationController
             ──secondViewController
```

## API
### Property
* navigationBarClass
* sb.disablesInteractivePop
* sb.navigationController
* sb.navigationController.useSystemBackBarButtonItem
* sb.navigationController.useRootNavigationBarAttributes
* sb.navigationController.actualTopViewController
* sb.navigationController.actualVisibleViewController
* sb.navigationController.actualViewControllers

### Method
* init(noWrappingRootViewController:)

### 已知问题
* iOS 14.0 及以上版本，调用 popToRootViewController(animated:) 方法返回跟视图控制器会意外出现 Back 按钮。

## 限制条件
- iOS 11.0+
- Swift 5.0+    

## 安装
### **Cocoapods**
```
pod 'SBNavigationController', '~> 1.0'
```
### **Swift Package Manager**
```
https://github.com/spirit-jsb/SBNavigationController.git
```

## 作者
spirit-jsb, sibo_jian_29903549@163.com

## 许可文件
`SBNavigationController` 可在 `MIT` 许可下使用，更多详情请参阅许可文件