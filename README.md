## 编译方法
工程使用 gulp 组织源代码和进行编译。

系统内需要安装 node.js
```
npm install -g gulp # 安装 gulp
npm install # 安装环境依赖
gulp watch # 启动编译进程
```

### 查看统计测试页
ruby -run -e httpd . -p 4000