#!/usr/bin/env bash
set -x
basePathRegex="^terragrunt/"
#GIT_PREVIOUS_COMMIT=""
if [ -z "${GIT_PREVIOUS_COMMIT}" ]; then
  fromCommit="HEAD~1"
else
  fromCommit="${GIT_PREVIOUS_COMMIT}"
fi
git find--name-status ${fromCommit} HEAD \
| grep -ve "^D" \
| awk '{print $NF}' \
| grep -e "${basePathRegex}" \
| grep -v terragrunt/terraform.tfvars \
| grep -v "terragrunt-cache" \
| xargs -r -n1 -P2 bash -xc 'tg apply --terragrunt-working-dir $(dirname ${0}) -auto-approve'

