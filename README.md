# iOS + Bitrise + SonarQube: Code Coverage Integration

This repository contains scripts and examples to enable **iOS code coverage reports** in **SonarQube** when running inside a **Bitrise pipeline**.

All the details are explained in the accompanying Medium article:  
👉 [Read the article](https://medium.com/@iharshaulouski/ios-bitrise-sonarqube-easy-code-coverage-integration-de58758bc7a5)

## Contents

- `prepare_sonarqube_latest_version_lookup.sh` — fetches the latest Sonar Scanner CLI version safely
- `prepare_sonarqube_parameters.sh` — prepares SonarQube parameters (PR/branch metadata, commit SHA, etc.)
- `prepare_sonarqube_fetch_branches.sh` — ensures reference branches are available for analysis
- `prepare_sonarqube_all.sh` — complete code for preparation step
- `codecoverage_sonarqube.sh` — converts `.xcresult` into SonarQube generic XML and normalizes paths

## Usage

These scripts are designed to be used as **Script steps** in a Bitrise Workflow.  
Combine them with `sonar-scanner` to run a complete analysis with coverage reporting.
