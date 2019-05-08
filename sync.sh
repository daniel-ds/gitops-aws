#!/usr/bin/env bash
set -x
find terragrunt/ -name "terraform.tfvars" \
| grep -v terragrunt/terraform.tfvars \
| grep -v "terragrunt-cache" \
| xargs -r -n1 -P2 bash -xc 'tg apply --terragrunt-working-dir $(dirname ${0}) -auto-approve'

