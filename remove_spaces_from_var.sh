#To remove leading and trailing whiespaces
trim() {
  local s2 s="$*"
  until s2="${s#[[:space:]]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[[:space:]]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  echo "$s"
}

trim "   vivek dubey"
trim "vivek dubey "
trim "   vivek dubey "


