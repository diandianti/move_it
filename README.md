# 什么是 move_it

move_it 可以按照文件的扩展名来整理某些文件夹内部的文件, 例如：

```bash
$ tree
.
├── a_10.txt
├── a_1.txt
... ...
├── a_8.txt
├── a_9.txt
├── b_10.bmp
├── b_1.bmp
├── b_2.bmp
... ...
├── b_9.bmp
├── c_10.mp4
├── c_1.mp4
├── c_2.mp4
... ...
├── c_9.mp4
├── d_10.pdf
├── d_1.pdf
├── d_2.pdf
... ...
├── d_9.pdf
├── fold1
... ...
├── fold9
├── z_10.zip
├── z_1.zip
... ...
├── z_8.zip
└── z_9.zip

$ move_it -d ./ ./

$ tree
.
├── compress
│   ├── z_10.zip
│   ├── ...
│   └── z_9.zip
├── dirs
│   ├── fold1
│   ├── ...
│   └── fold9
├── doc
│   ├── a_10.txt
│   ├── ...
│   └── a_9.txt
├── ebook
│   ├── d_10.pdf
│   ├── ...
│   └── d_9.pdf
├── image
│   ├── b_10.bmp
│   ├── ...
│   └── b_9.bmp
└── video
    ├── c_10.mp4
    ├── ...
    └── c_9.mp4

```


# 如何使用

## 安装
```bash
git clone https://github.com/diandianti/move_it.git
cd move_it
ln -s /path/to/move_it.sh /usr/bin/move_it
```
## 使用
```
move_it [option] <input>
```


# 控制参数

由于整个脚本都是使用bash命令，所以参数都只能都在命令之后，如果参数放在了处理路径的后面会导致出错：

- v: 打印更多的log
- V: 打印版本号
- R: 递归处理所有的子文件夹
- h: 帮助命令
- n: 不处理子文件夹
- d: 临时改变输出目录

