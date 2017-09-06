## 介绍
一个`Bash`下的书签管理工具，仅用一个命令（实际是函数）`J`（可以更改）就可以完成书签增删查、目录跳转  
这是 [oh-my-zsh jump](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/jump/jump.plugin.zsh) 的改进版，使用起来会更方便
，有自动补全同时支持多种`shell`  
原理是把数据以软链接的方式存在`~/marks`目录下。具体用法见下：

``` bash
$ J -h
Usage:
  J           - Lists all marks
  J <mark>    - Goes (cd) to the directory associated with <mark>
  J -s <mark> - Saves the current directory as <mark>
  J -d <mark> - Deletes the <mark>
```

## 使用
运行 `git clone https://github.com/SaulLawliet/bashJ.git`  
将`source <dir>/bashJ.sh`加入你的`~/.bash_profile`或`~/.bashrc`或`~/.zshrc`  
默认命令是`J`，如要更改，你可以编辑`bashJ.sh`，把`J`改成任意你喜欢的命令
