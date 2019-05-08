# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an S3 bucket

  # Configure root level variables that all resources can inherit
  terraform {
    source = "${path_relative_from_include()}/BLAH"

    extra_arguments "common_vars" {
      commands = [
        "${get_terraform_commands_that_need_vars()}"]

      optional_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("env.tfvars", "ignore")}",
      ]
    }

    # Force Terraform to not ask for input value if some variables are undefined.
    extra_arguments "disable_input" {
      commands = [
        "${get_terraform_commands_that_need_input()}"]
      arguments = [
        "-input=false"]
    }

    # Force Terraform to keep trying to acquire a lock for up to 10 minutes if someone else already has the lock
    extra_arguments "retry_lock" {
      commands = [
        "${get_terraform_commands_that_need_locking()}"]
      arguments = [
        "-lock-timeout=10m"]
    }
    extra_arguments "set_aws_env" {
      commands = [
        "apply",
        "plan",
        "import",
        "destroy",
        "refresh",
      ]

      env_vars = {
        YAA = "${path_relative_from_include()}/BLAH"
      }
    }
  }
}
