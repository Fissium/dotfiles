local M = {}

M.linters_by_ft = {
	-- docker
	dockerfile = { "hadolint" },
	-- yaml
	yaml = { "yamllint", "typos" },
	-- terraform
	tf = { "tflint", "typos" },
	terraform = { "tflint", "typos" },
	["terraform-vars"] = { "tflint", "typos" },
	-- python
	python = { "typos" },
	-- bash
	bash = { "typos" },
}

return M
