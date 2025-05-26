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
	-- markdown
	markdown = { "markdownlint-cli2" },
}

return M
