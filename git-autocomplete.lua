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

function startsWith(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

function endsWith(str, _end)
	return string.sub(str, string.len(str) - string.len(_end) + 1) == _end
end

function isAlias(text)
	if startsWith(text, "git branch") then
		return true
	end

	for i, _alias in ipairs(branchAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git checkout") then
		return true
	end

	for i, _alias in ipairs(checkoutAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git diff") then
		return true
	end

	for i, _alias in ipairs(diffAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git fetch") then
		return true
	end

	for i, _alias in ipairs(fetchAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git merge") then
		return true
	end

	for i, _alias in ipairs(mergeAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git pull") then
		return true
	end

	for i, _alias in ipairs(pullAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git push") then
		return true
	end

	for i, _alias in ipairs(pushAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git rebase") then
		return true
	end

	for i, _alias in ipairs(rebaseAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git reset") then
		return true
	end

	for i, _alias in ipairs(resetAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git show") then
		return true
	end

	for i, _alias in ipairs(showAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git show-branch") then
		return true
	end

	for i, _alias in ipairs(showBranchAliases) do
		if startsWith(text, "git ".._alias) then
			return true
		end
	end

	if startsWith(text, "git switch") then
		return true
	end

	for i, _alias in ipairs(switchAliases) do
		if startsWith(text, "git ".._alias) then
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

	if startsWith(result, "fatal") == false then
		for branch in string.gmatch(result, "[* ]%s.%S+") do
			if string.sub(branch, 0, 1) == "*" then
				branch = string.gsub(branch, "* ", "")
			elseif startsWith(branch, "  remotes/") == true then
				branch = string.gsub(branch, "  remotes/", "")
			else
				branch = string.gsub(branch, "  ", "")
			end
			table.insert(branches, branch)
		end
	end

	return branches
end

function getRemotes()
	local handle = io.popen("git remote -v 2>&1")
	local result = handle:read("*a")
	handle:close()

	local remotes = {}

	if startsWith(result, "fatal") == false then
		for remote in string.gmatch(result, "%S+") do
			if string.sub(remote, 0, 1) ~= "(" then
				table.insert(remotes, remote)
			end
		end
	end

	return remotes
end

function gitAutocomplete(text)
	local matchCount = 0

	if isAlias(rl_state.line_buffer) then
		local branches = getBranches()
		for i, branch in ipairs(branches) do
			if startsWith(branch, text) then
				clink.add_match(branch)
				matchCount = matchCount + 1
			end
		end

		local remotes = getRemotes()
		for i, remote in ipairs(remotes) do
			if startsWith(remote, text) then
				clink.add_match(remote)
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
	if endsWith(alias, " branch") then
		table.insert(branchAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " checkout") then
		table.insert(checkoutAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " diff") then
		table.insert(diffAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " fetch") then
		table.insert(fetchAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " merge") then
		table.insert(mergeAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " pull") then
		table.insert(pullAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " push") then
		table.insert(pushAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " rebase") then
		table.insert(rebaseAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " reset") then
		table.insert(resetAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " show") then
		table.insert(showAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " show-branch") then
		table.insert(showBranchAliases, string.gmatch(alias, "%S+")())
	end
	if endsWith(alias, " switch") then
		table.insert(switchAliases, string.gmatch(alias, "%S+")())
	end
end

local aliases = {}

for alias in string.gmatch(result, "%.(%S+)") do
  table.insert(aliases, alias)
end

clink.arg.register_parser("git", aliases)
clink.register_match_generator(gitAutocomplete, 1)
