ensurePath(){
  for dir in "${@}"; do
    if [ ! -d "${dir}" ]; then
      mkdir -p "${dir}"
    fi

  done
}
ensureFile(){
  for file in "${@}"; do
    if [ ! -f "${file}" ]; then
      mkdir -p "$( dirname -- "${file}" )"
      touch "${file}"
    fi
  done
}
ensurePath "${HOME}/.local/bin"
ensurePath "${HOME}/.local/profile.d"
ensureFile "${HOME}/.local/profile.d/env"

# standard user folders
ensurePath "${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Music" "$HOME/Pictures" "${HOME}/Public" "${HOME}/Templates" "${HOME}/Videos"

for env in "${HOME}/.local/profile.d"/*; do
  . "${env}"
done

export PATH="${HOME}/.local/bin:${PATH}"

unset ensurePath
unset ensureFile
