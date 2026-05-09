# Put files in this folder to add your own custom functionality.
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Customization
#
# Files in the custom/ directory will be:
# - loaded automatically by the init script, in alphabetical order
# - loaded last, after all built-ins in the lib/ directory, to override them
# - ignored by git by default

########## alias 配置 {{{
alias vim="nvim" # 使用nvim替换vim
alias cls=" clear"
alias ref=". ~/.zshrc"
alias zshrc-edit="nvim ~/.zshrc"
alias zshrc-read=" nvim -M ~/.zshrc"
alias zshrc=" zshrc-read"
alias zshrc-custom-cd=" cd ~/.oh-my-zsh/custom"
alias zshrc-custom-edit="nvim ~/.oh-my-zsh/custom/custom.zsh" # 快速编辑自定义zsh配置文件
alias zshrc-custom-read=" nvim -M ~/.oh-my-zsh/custom/custom.zsh"
alias zshrc-custom=" zshrc-custom-read"
alias ht=" history -t'%F %T' " # 以"yyyy-mm-dd HH:MM:ss"打印历史
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"

# colorls 配置 
# ~/.oh-my-zsh/lib/directories.zsh
unalias lsa
unalias l
unalias ll
unalias la
# see: https://github.com/athityakumar/colorls
alias ls=" colorls"     # 使用colorls代替ls 并且在前面加一个空格实现隐藏history
alias l=" colorls -Al --sd --report"
alias la="ls -A --sd"   # 所有文件 优先显示文件夹
alias lg="la --gs"      # 所有文件 显示git状态
alias ld="la -d"        # 仅文件夹
alias lf="la -f"        # 仅文件
alias lt="la -t"        # 所有文件 优先显示文件夹 修改时间降序
alias ll="la -l"        # 所有文件 优先显示文件夹 列表
alias lgl="lg -l"
alias ldl="ld -l"
alias lfl="lf -l"
alias ltl="lt -l"
########### }}}


########## zsh 配置 {{{
    #历史纪录条目数量
    export HISTSIZE=10000
    #注销后保存的历史纪录条目数量
    export SAVEHIST=10000
    #历史纪录文件
    # export HISTFILE=$HOME/.zsh_history
    #以附加的方式写入历史纪录
    setopt INC_APPEND_HISTORY
    #如果连续输入的命令相同，历史纪录中只保留一个
    setopt HIST_IGNORE_DUPS      
    #为历史纪录中的命令添加时间戳      
    setopt EXTENDED_HISTORY      
    #启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
    setopt AUTO_PUSHD
    #相同的历史路径只保留一个
    setopt PUSHD_IGNORE_DUPS
    #在命令前添加空格，不将此命令添加到纪录文件中
    setopt HIST_IGNORE_SPACE   
    #以下字符视为单词的一部分
    WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

    # 别名查询
    zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
    zstyle ':omz:plugins:alias-finder' longer yes   # disabled by default
    zstyle ':omz:plugins:alias-finder' exact yes    # disabled by default
    zstyle ':omz:plugins:alias-finder' cheaper yes  # disabled by default
########## }}}