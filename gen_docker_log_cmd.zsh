# 转义函数（供内部使用）
_escape_for_awk() {
  local str="$1"
  printf '%s\n' "$str" | sed -e 's/[.[\*^$/]/\\&/g' -e 's/\//\\\//g'
}

# 交互式调用
gen_docker_log_cmd() {
  local container
  local find_str1
  local find_str2
  read_input "请输入容器名称（container）: " container "contianer"
  read_input "请输入需要匹配的内容1（必填）: " find_str1 "str1"
  read_input "请输入需要匹配的内容2（可空）: " find_str2 ""
  gen_docker_log_cmd_args "$container" "$find_str1" "$find_str2"
}

# 非交互式调用
gen_docker_log_cmd_args() {
  local container="$1"
  local find_str1="$2"
  local find_str2="$3"

  if [[ -z "$container" || -z "$find_str1" ]]; then
    warn "用法: gen_docker_log_cmd_args <container> <match1> [match2]"
    return 1
  fi

  local awk_pattern1
  local awk_pattern2
  awk_pattern1=$(_escape_for_awk "$find_str1")
  awk_pattern2=$(_escape_for_awk "$find_str2")

  echo  
  success "生成的命令如下："
  echo
  if [[ -n "$find_str2" ]]; then
    info "docker logs --tail 99999 $container 2>&1 | awk '/$awk_pattern1/{flag=1} flag; /$awk_pattern2/{flag=0}'"
    echo
  fi
  info "docker logs --tail 99999 $container 2>&1 | awk '/$awk_pattern1/{start=1} start'"
}
