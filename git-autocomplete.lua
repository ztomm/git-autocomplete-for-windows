local branchAliases = {}
local checkoutAliases = {}
local diffAliases = {}
local fetchAliases = {}
local mergeAliases = {}
local pullAliases = {}
local pushAliases = {}
local rebaseAliases = {}
local resetAliases = {}
local showAliases = {}
local showBranchAliases = {}
local switchAliases = {}

function string.starts(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

function string.ends(str, _end)
	return string.sub(str, string.len(str) - string.len(_end) + 1) == _end
end

function isAlias(text)
	if string.starts(text, "git branch") then
		return true
	end

	for i, _alias in ipairs(branchAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git checkout") then
		return true
	end

	for i, _alias in ipairs(checkoutAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git diff") then
		return true
	end

	for i, _alias in ipairs(diffAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git fetch") then
		return true
	end

	for i, _alias in ipairs(fetchAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git merge") then
		return true
	end

	for i, _alias in ipairs(mergeAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git pull") then
		return true
	end

	for i, _alias in ipairs(pullAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git push") then
		return true
	end

	for i, _alias in ipairs(pushAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git rebase") then
		return true
	end

	for i, _alias in ipairs(rebaseAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git reset") then
		return true
	end

	for i, _alias in ipairs(resetAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git show") then
		return true
	end

	for i, _alias in ipairs(showAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git show-branch") then
		return true
	end

	for i, _alias in ipairs(showBranchAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	if string.starts(text, "git switch") then
		return true
	end

	for i, _alias in ipairs(switchAliases) do
		if string.starts(text, "git ".._alias) then
			return true
		end
	end

	return false
end

function getBranches()
	local handle = io.popen("git branch -a 2>&1")
	local result = handle:read("*a")
	handle:close()

	local branches = {}

	if string.starts(result, "fatal") == false then
		for branch in string.gmatch(result, "  %S+") do
			branch = string.gsub(branch, "  ", "")

			if branch ~= "HEAD" then
				table.insert(branches, branch)
			end
		end
	end

	return branches
end

function gitAutocompleteBranches(text, first, last)
	local matchCount = 0

	if isAlias(rl_state.line_buffer) then
		local branches = getBranches()

		for i, branch in ipairs(branches) do
			if string.starts(branch, text) then
				clink.add_match(branch)
				matchCount = matchCount + 1
			end
		end
	end

	return matchCount > 0
end

local handle = io.popen("git config --get-regex alias")
local result = handle:read("*a")
handle:close()

for alias in string.gmatch(result, "%.(%S+ %S+)") do
	if string.ends(alias, " branch") then
		table.insert(branchAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " checkout") then
		table.insert(checkoutAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " diff") then
		table.insert(diffAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " fetch") then
		table.insert(fetchAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " merge") then
		table.insert(mergeAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " pull") then
		table.insert(pullAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " push") then
		table.insert(pushAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " rebase") then
		table.insert(rebaseAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " reset") then
		table.insert(resetAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " show") then
		table.insert(showAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " show-branch") then
		table.insert(showBranchAliases, string.gmatch(alias, "%S+")())
	end
	if string.ends(alias, " switch") then
		table.insert(switchAliases, string.gmatch(alias, "%S+")())
	end
end

local aliases = {}

for alias in string.gmatch(result, "%.(%S+)") do
  table.insert(aliases, alias)
end

clink.arg.register_parser("git", aliases)
clink.register_match_generator(gitAutocompleteBranches, 1)
