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