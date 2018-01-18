1.什么是.DS_Store？

.DS_Store,用于存储当前文件夹的一些Meta信息。每次提交代码时，我都要在代码仓库的.gitignore中声明，忽略这类文件。

2.存在哪些问题？

如果你没有忽略此类文件时，你和你的小伙伴和代码时就会有如下的问题：
error: Your local changes to the following files would be overwritten by merge: .DS_Store
或：
both modified: .DS_Store

3.解决办法

1. 本地仓库忽略

本地仓库的文件忽略规则可以在 .git/info/exclude 文件中添加。这些忽略的文件不会提交到共享库中，因而不会被协作者所共享。(我没试过)
# git ls-files --others --exclude-from=.git/info/exclude
# Lines that start with '#' are comments.
# For a project mostly in C, the following would be a good set of
# exclude patterns (uncomment them if you want to use them):
# *.[oa]
# *~

2.当前工作目录添加文件忽略

·就是.gitignore,这个忽略文件只对某一级目录下的文件的忽略有效;
·如果某一个目录下有需要被忽略的文件,那么就可以在该目录下手工地创建忽略文件.gitignore,
·并在这个忽略文件中写上忽略规则,以行为单位,一条规则占据一行;
·比较特殊的情况就是在版本库的根目录下创建一个忽略文件.gitignore,这时,
这个.gitignore忽略文件就对版本库根目录下的文件有效,等价于全局范围内的忽略文件.git/info/exclude;

对于每一级工作目录，创建一个.gitignore文件，向该文件中添加要忽略的文件或目录。
但在创建并编辑这个文件之前，一定要保证要忽略的文件没有添加到git索引中。
使用命令 git rm --cached filename将要忽略的文件从索引中删除。

--摘抄.gitignore的格式规范
• 所有空行或者以注释符号 # 开头的行都会被 Git 忽略。
• 可以使用标准的 glob 模式匹配。
• 匹配模式最后跟反斜杠(/)说明要忽略的是目录。
• 要忽略指定模式以外的文件或目录,可以在模式前加上惊叹号(!)取反。
•所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。
•星号(*)匹配零个或多个任意字符;
•[abc] 匹配任何一个列在方括号中的字符(这个例子要么匹配一个 a,要么匹配一个 b,要么匹配一个 c);
•问号(?)只匹配一个任意字符;
•如果在方括号中使用短划线分隔两个字符,表示所有在这两个字符范围内的都可以匹配(比如[0-9]表示匹配所有 0 到 9 的数字)。
3.配置全局的.gitignore

1、用touch .gitignore_global创建~/.gitignore_global文件，把需要全局忽略的文件类型塞到这个文件里。（我试过）

# .gitignore_global
####################################
######## OS generated files ########
####################################
.DS_Store
.DS_Store?
*.swp
._*
.Spotlight-V100
.Trashes
Icon?
ehthumbs.db
Thumbs.db
####################################
############# packages #############
####################################
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip
2、在~/.gitconfig中引入.gitignore_global。

这是我的.gitconfig文件:

[user]
name = duofei
email = xxxxx@gmail.com
[push]
default = matching
[core]
excludesfile =/Users/duofei/.gitignore_global
多飞提示！

这个坑一定要记住，一定要在一开始就配置忽略文件（在第一次次push之前），如果忘记配置那么到后期远程仓库就会跟踪你的.DS_Store，那么你就总会出现这种情况了；
error: Your local changes to the following files would be overwritten by merge: .DS_Store
或：
both modified: .DS_Store
反正就是各种不能如愿的和小伙伴pull、push
如果一开始的时候忘记配置了忽略文件的话，也不要怕，通过以下方法来做更改：
git rm -r --cached .DS_Store
这句代码的意思就是解除跟踪，清一清缓存；
然后在配好忽略文件就好OK了！

作者：多飞
链接：https://www.jianshu.com/p/9386124cb5b5
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
