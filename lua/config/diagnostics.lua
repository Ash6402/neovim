local M = {}

local function detect_project()
	local root = vim.fn.getcwd()
	local files = vim.fn.readdir(root)
	local set = {}
	for _, f in ipairs(files) do
		set[f] = true
	end

	if set["angular.json"] then
		return "angular"
	end
	if set["tsconfig.json"] then
		return "ts-react"
	end
	if set["vite.config.ts"] then
		return "ts-react"
	end
	if set["vite.config.js"] then
		return "js-react"
	end
	if set["package.json"] then
		return "js"
	end
	return "unknown"
end

-- Parse tsc output: file(line,col): error TS000: msg
local function parse_tsc(output)
	local items = {}
	for line in output:gmatch("[^\n]+") do
		local file, lnum, col, msg = line:match("^(.+)%((%d+),(%d+)%):%s*(.+)$")
		if file then
			table.insert(items, {
				filename = file,
				lnum = tonumber(lnum),
				col = tonumber(col),
				text = msg,
				type = msg:match("error") and "E" or "W",
			})
		end
	end
	return items
end

-- Parse eslint JSON output: file:line:col: msg
local function parse_eslint(output)
	local items = {}
	-- find the first '[' that is followed by '{' (start of JSON array of objects)
	local json_start = output:find("%[{")
	if not json_start then
		return items
	end
	local json_str = output:sub(json_start)

	local ok, decoded = pcall(vim.fn.json_decode, json_str)
	if not ok then
		return items
	end

	for _, file_result in ipairs(decoded) do
		for _, msg in ipairs(file_result.messages) do
			table.insert(items, {
				filename = file_result.filePath,
				lnum = msg.line or 1,
				col = msg.column or 1,
				text = msg.message .. " [" .. (type(msg.ruleId) == "string" and msg.ruleId or "?") .. "]",
				type = msg.severity == 2 and "E" or "W",
			})
		end
	end
	return items
end

-- Shared: run a command, parse output, show in fzf-lua
local function run_and_show(cmd, parser, title)
	vim.notify("Running: " .. title .. "…", vim.log.levels.INFO)

	local output_lines = {}

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			for _, line in ipairs(data) do
				table.insert(output_lines, line)
			end
		end,
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				table.insert(output_lines, line)
			end
		end,
		on_exit = function()
			local output = table.concat(output_lines, "\n")
			local items = parser(output)

			if #items == 0 then
				vim.notify("✓ No issues found", vim.log.levels.INFO)
				return
			end
			vim.fn.setqflist(items, "r")
			require("fzf-lua").quickfix({
				winopts = {
					title = " " .. title .. " ",
					height = 0.8,
					width = 0.8,
				},
			})
		end,
	})
end

-- Command 1: TypeScript type errors (tsc) — only for TS projects
function M.type_errors()
	local ptype = detect_project()

	if ptype == "unknown" then
		vim.notify("No package.json found", vim.log.levels.WARN)
		return
	end

	-- TS projects: use tsc for real type errors
	if ptype == "ts-react" then
		run_and_show("npx tsc --noEmit 2>&1", parse_tsc, "ts type errors")
		return
	end

	if ptype == "angular" then
		run_and_show("npx tsc -p tsconfig.app.json --noEmit 2>&1", parse_tsc, "angular type errors")
		return
	end

	-- JS projects: no tsc, fall back to eslint with type-aware rules
	vim.notify("JS project — using eslint for diagnostics", vim.log.levels.INFO)
	-- keep the --ext flag for ESLint <v9 projects
	run_and_show("npx eslint . --ext .js,.jsx --format json 2>&1", parse_eslint, ptype .. " diagnostics")
end

-- Command 2: Lint errors (eslint) — works for JS and TS, any project
function M.lint_errors()
	local ptype = detect_project()
	if ptype == "unknown" then
		vim.notify("No package.json found", vim.log.levels.WARN)
		return
	end
	-- Covers both .js/.jsx and .ts/.tsx in one pass
	-- keep the --ext flag for ESLint <v9 projects
	local cmd = "npx eslint . --ext .js,.jsx,.ts,.tsx --format json 2>&1"
	run_and_show(cmd, parse_eslint, ptype .. " lint errors")
end

return M
