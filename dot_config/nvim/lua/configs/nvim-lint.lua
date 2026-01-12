local M = {}

M.linters_by_ft = {
	-- docker
	dockerfile = { "hadolint" },
	-- yaml
	yaml = { "yamllint" },
	-- terraform
	tf = { "tflint", "terraform_validate" },
	terraform = { "tflint", "terraform_validate" },
	["terraform-vars"] = { "tflint" },
	-- ansible
	ansible = { "ansible_lint" },
	-- json
	json = { "jsonlint" },
}

return M
