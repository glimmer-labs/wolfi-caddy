#!/usr/bin/env bats

setup() {
  MOCKDIR="$(mktemp -d)"
  cp ./tests/mocks/* "$MOCKDIR/"
  chmod +x "$MOCKDIR/"*

  export PATH="$MOCKDIR:$PATH"

  cp ./rootfs/usr/local/bin/dxcaddy ./dxcaddy-test.sh
  chmod +x ./dxcaddy-test.sh
}

teardown() {
  rm -rf "$MOCKDIR"
  rm -f ./dxcaddy-test.sh
}

@test "shows help with --help flag" {
  run ./dxcaddy-test.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: ./dxcaddy-test.sh [modules...]"* ]]
  [[ "$output" == *"Downloads Caddy binary from the official API."* ]]
}

@test "installs Caddy without modules using caddy add-package" {
  run ./dxcaddy-test.sh
  [ "$status" -eq 0 ]
  [[ "$output" == *"apk called with: add --no-cache caddy"* ]]
  [[ "$output" == *"[SUCCESS] Caddy updated correctly"* ]]
}

@test "installs Caddy with modules using caddy add-package" {
  run ./dxcaddy-test.sh github.com/example/module github.com/foo/bar
  [ "$status" -eq 0 ]
  [[ "$output" == *"Modules: github.com/example/module,github.com/foo/bar"* ]]
  [[ "$output" == *"caddy add-package called with: github.com/example/module github.com/foo/bar"* ]]
  [[ "$output" == *"Modules installed with caddy 'add-package' correctly"* ]]
}

@test "falls back to download when caddy add-package not supported" {
  export SIMULATE_CADDY_NO_ADD_PACKAGE=1

  run ./dxcaddy-test.sh github.com/example/module
  echo $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"Falling back to download from Caddy API..."* ]]
  [[ "$output" == *"curl called with: -fsSL"* ]]
  [[ "$output" == *"Caddy installed correctly from API"* ]]
}

@test "falls back to xcaddy build when API download fails" {
  export SIMULATE_CADDY_NO_ADD_PACKAGE=1
  export SIMULATE_CURL_FAILURE=1

  run ./dxcaddy-test.sh github.com/example/module
  echo $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"[SUCCESS] Caddy built correctly with xcaddy"* ]]
}

@test "fails if xcaddy build fails" {
  export SIMULATE_CADDY_NO_ADD_PACKAGE=1
  export SIMULATE_CURL_FAILURE=1
  export SIMULATE_XCADDY_FAILURE=1

  run ./dxcaddy-test.sh github.com/example/module
  [ "$status" -ne 0 ]
  [[ "$output" == *"[ERROR] Failed to build Caddy with xcaddy"* ]]
}