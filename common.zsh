# 打印成功日志
success() {
    echo "\033[32m$1\033[0m"
}

# 打印错误日志
error() {
    echo "\033[31m$1\033[0m"
}

# 打印警告日志
warn() {
    echo "\033[33m$1\033[0m"
}

# 打印信息日志
info() {
    echo "\033[36m$1\033[0m"
}

# 确认执行操作
confirm() {
    local prompt="$1"
    echo -n "$prompt (y/n): "  # 使用 `echo -n` 提示用户
    read response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0  # 用户选择 "是"
            ;;
        *)
            return 1  # 用户选择 "否"
            ;;
    esac
}


# 检查命令是否存在
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        error "命令 '$cmd' 未找到，请安装后重试。"
        return 1
    fi
    success "命令 '$cmd' 可用。"
}

# 检查文件是否存在
check_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        success "文件 '$file' 存在。"
    else
        error "文件 '$file' 不存在。"
        return 1
    fi
}

# 运行命令并检查退出状态
run_command() {
    local cmd="$1"
    info "正在执行命令: $cmd"
    eval "$cmd"
    if [[ $? -eq 0 ]]; then
        success "命令执行成功。"
    else
        error "命令执行失败。"
        return 1
    fi
}


# 写入内容到文件
write_to_file() {
    local content="$1"
    local file="$2"
    echo "$content" > "$file"
    if [[ $? -eq 0 ]]; then
        success "成功写入到文件 '$file'。"
    else
        error "写入文件 '$file' 失败。"
        return 1
    fi
}

# 检查目录是否存在
check_directory() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        success "目录 '$dir' 存在。"
    else
        error "目录 '$dir' 不存在。"
        return 1
    fi
}

# 读取用户输入
read_input() {
    local prompt="$1"
    local var_name="$2"
    local default_value="$3"

    # 如果默认值为空，则使用空字符串
    if [[ -n "$default_value" ]]; then
        prompt="$prompt (默认: $default_value)"
    fi

    echo -n "$prompt "  # 显示提示信息
    read input          # 读取用户输入

    # 如果用户没有输入，使用默认值
    if [[ -z "$input" && -n "$default_value" ]]; then
        input="$default_value"
    fi

    eval "$var_name='$input'"  # 将用户输入赋值给指定变量

    # 输出用户输入的值（如果有输入）
    # [[ -z "$input" ]] || success "输入的值为: $input"
}

# 开启代理
on() {
    export http_proxy="http://127.0.0.1:7897"
    export https_proxy=$http_proxy
    export all_proxy=socks5://127.0.0.1:7897
    success "代理启动"
}
# 关联代理
off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    warn "代理关闭"
}

# 清理maven仓库
clean() {
    # 默认路径为 ~/.m2/repository
    local default_path="~/.m2/repository"
    local run_path

    # 将路径中的 ~ 展开为实际的用户目录
    default_path=$(eval echo ~$USER)/.m2/repository

    # 提示用户输入路径，默认使用 ~/.m2/repository
    read_input "请输入要清理的路径" run_path $default_path

    if ! check_directory "$run_path"; then
        return 1  # 如果目录不存在，退出函数或脚本
    fi

    # 提示用户确认是否添加基础查询条件
    local conditions=()
    if confirm "是否包括 *.lastUpdated 文件？"; then
        conditions+=("-name \"*.lastUpdated\"")
    fi
    if confirm "是否包括 *.part 文件？"; then
        conditions+=("-name \"*.part\"")
    fi
    if confirm "是否包括 *.part.lock 文件？"; then
        conditions+=("-name \"*.part.lock\"")
    fi
    if confirm "是否包括 '_remote.repositories' 文件？"; then
        conditions+=("-name \"_remote.repositories\"")
    fi
    if confirm "是否包括空目录？"; then
        conditions+=("-type d -empty")
    fi

    # 如果没有选择任何条件，则退出
    if [ ${#conditions[@]} -eq 0 ]; then
        warn "没有选择任何查询条件，退出清理操作。"
        return 1
    fi

    # 构建 find 命令
    local cmd="find $run_path \\( "
    for cond in "${conditions[@]}"; do
        cmd+="$cond -o "
    done
    cmd="${cmd::-4}"  # 去掉最后一个多余的 "-o"
    cmd+=" \\) -print"

    # 打印构建的命令以供调试
    # info "构建的查找命令：$cmd"

    # 执行查找并显示结果
    info "正在查找以下文件和目录："
    run_command "$cmd"

    # 确认删除操作
    if confirm "是否确认删除找到的文件和目录"; then
        cmd+=" -delete"
        info "正在删除匹配项..."
        run_command "$cmd"
        success "清理完成。"
    else
        warn "清理操作已取消。"
    fi
}

# 更新docker镜像
update_latest_images() {
    # 查找所有版本为 latest 的镜像
    local images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep ":latest")

    # 如果没有找到 latest 镜像，提示并退出
    if [[ -z "$images" ]]; then
        info "未找到任何 latest 版本的镜像。"
        return 0
    fi

    # 列出所有 latest 镜像
    info "以下是所有版本为 latest 的镜像："
    echo "$images"

    # 确认是否更新
    if confirm "是否更新所有 latest 镜像？"; then
        # 循环更新镜像
        while IFS= read -r image; do
            info "正在更新镜像: $image"
            run_command "docker pull $image"
        done <<< "$images"
        success "所有 latest 镜像更新完成。"
    else
        warn "镜像更新操作已取消。"
    fi
}
