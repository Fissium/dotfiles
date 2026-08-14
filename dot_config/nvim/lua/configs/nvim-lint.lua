local M = {}

M.linters_by_ft = {
	-- docker
	dockerfile = { "hadolint" },
	-- yaml
	yaml = { "yamllint" },
	-- terraform/opentofu
	tf = { "tflint", "tofu" },
	terraform = { "tflint", "tofu" },
	["terraform-vars"] = { "tflint" },
	-- ansible
	ansible = { "ansible_lint" },
	-- json
	json = { "jsonlint" },
	-- rego
	rego = { "opa_check" },
	-- make
	make = { "mbake" },
}

return M
