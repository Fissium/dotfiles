local M = {}

M.linters_by_ft = {
	-- docker
	dockerfile = { "hadolint" },
	-- yaml
	yaml = { "yamllint" },
	-- terraform
	tf = { "tflint" },
	terraform = { "tflint" },
	["terraform-vars"] = { "tflint" },
}

return M
