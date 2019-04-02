# GlobalegrowBugTag-Server

[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu)     [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

基于 [Swift Perfect](https://github.com/PerfectlySoft/Perfect) 服务器框架为基础的的 BUG 日志上报服务器

## 启动

```shell
$ git clone git@github.com:globalegrowbugtag/GlobalegrowBugTag-Server.git
$ cd GlobalegrowBugTag-Server
$ Swift build
$ Swift run
```

## 开发/修改

```shell
$ git clone git@github.com:globalegrowbugtag/GlobalegrowBugTag-Server.git
$ cd GlobalegrowBugTag-Server
$ swift package -v generate-xcodeproj
```

配置工程运行路径

![image-20190402150854550](http://ipicimage-1251019290.coscd.myqcloud.com/2019-04-02-071244.png)

### 安装 MySQL

[安装支持的 MySQL 服务](https://github.com/PerfectlySoft/Perfect-MySQL)

#### 配置 MySQL 数据库信息

前往 `Source/Logger/DB/`路径下面打开 `DataBase.swift`文件在源码配置

