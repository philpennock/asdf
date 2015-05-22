install_command() {
  local package_name=$1
  local full_version=$2
  local plugin_path=$(get_plugin_path $package_name)
  check_if_plugin_exists $plugin_path

  IFS=':' read -a version_info <<< "$full_version"
  if [ "${version_info[0]}" = "ref" ]; then
    local install_type="${version_info[0]}"
    local version="${version_info[1]}"
  else
    local install_type="version"
    local version="${version_info[0]}"
  fi

  local install_path=$(get_install_path $package_name $install_type $version)
  (
    export ASDF_INSTALL_TYPE=$install_type
    export ASDF_INSTALL_VERSION=$version
    export ASDF_INSTALL_PATH=$install_path
    bash ${plugin_path}/bin/install
  )
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    reshim_command $package_name $full_version
  else
    exit $exit_code
  fi
}
