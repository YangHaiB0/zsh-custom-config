# 清理maven仓库
clean_mvn_repository() {
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