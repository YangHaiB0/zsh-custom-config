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
