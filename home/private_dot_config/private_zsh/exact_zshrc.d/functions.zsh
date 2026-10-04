docker-size() {
  docker manifest inspect $1 | jq -r '.config.size + ([.layers[].size] | add)' | numfmt --to=iec
}
