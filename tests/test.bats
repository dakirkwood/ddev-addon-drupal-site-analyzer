#!/usr/bin/env bats

# Basic tests for DDEV Drupal Site Analyzer addon

setup() {
    export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
    export TESTDIR="${DIR}/tests/test-project"
    export PROJNAME="test-drupal-site-analyzer"
    
    # Ensure test project directory exists
    mkdir -p "${TESTDIR}"
    cd "${TESTDIR}" || exit 1
    
    # Initialize DDEV if not already done
    if [ ! -f .ddev/config.yaml ]; then
        ddev config --project-name=${PROJNAME} --project-type=drupal10 --docroot=web
    fi
}

teardown() {
    cd "${TESTDIR}" || exit 1
    ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}

@test "install addon" {
    cd ${TESTDIR}
    echo "# Installing addon from ${DIR}"
    ddev get ${DIR}
    ddev restart
}

@test "drupal-site-analyzer command exists" {
    cd ${TESTDIR}
    ddev get ${DIR}
    # Command should show help when run without Drupal
    run ddev drupal-site-analyzer --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Drupal Site Analyzer" ]]
}

@test "drupal-site-analyzer version" {
    cd ${TESTDIR}
    ddev get ${DIR}
    run ddev drupal-site-analyzer --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Drupal Site Analyzer v1.0.0" ]]
}

@test "drupal-site-analyzer help output" {
    cd ${TESTDIR}
    ddev get ${DIR}
    run ddev drupal-site-analyzer --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "--format" ]]
    [[ "$output" =~ "--entity-type" ]]
    [[ "$output" =~ "--bundle" ]]
}

# Note: Full functionality tests would require a Drupal installation
# with exported configuration. These basic tests verify the addon
# installs correctly and the command is available.