local commandAliases = {
	"add", "bisect", "branch", "checkout", "clone", "commit", "diff", "fetch", 
	"grep", "init", "log", "merge", "mv", "pull", "push", "rebase", "reset", 
	"restore", "rm", "show", "show-branch", "switch", "stash", "status", "tag"
}
local branchLocalAliases = {
	"checkout", "push", "switch"
}
local branchRemoteAliases = {
	"branch", "diff", "fetch", "merge", "pull", "rebase", "reset", "show", "show-branch"
}
local resetAliases = {
	"add", "mv", "restore", "rm"
}

local gitAutocomplete = clink.generator(10)

local function startsWith(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

local function hasValue(table, value)
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function getBranchesLocal(alias)
	local handle = io.popen("git branch -a 2>&1")
	local result = handle:read("*a")
	handle:close()
	if startsWith(result, "fatal") == false then
		for branch in string.gmatch(result, "[* ]%s.%S+") do
			branch = string.gsub(branch, "^%*%s*", "")
			branch = string.gsub(branch, "^%s*remotes/", "")
			branch = string.gsub(branch, "^%s+", "")
			clink.argmatcher("git"):addarg(alias):addarg(branch):nofiles()
			clink.argmatcher("git"):addarg(alias):addarg("origin"):addarg(branch):nofiles()
		end
	end
end

local function getBranchesRemote(alias)
	local handle = io.popen("git remote -v 2>&1")
	local result = handle:read("*a")
	handle:close()
	if startsWith(result, "fatal") == false then
		for branch in string.gmatch(result, "%S+") do
			if string.sub(branch, 0, 1) ~= "(" and startsWith(branch, "http") == false then
				clink.argmatcher("git"):addarg(alias):addarg(branch):nofiles()
			end
		end
	end
end

local function rebuildArgs()
	clink.argmatcher("git"):reset()
	clink.argmatcher("git"):addarg(commandAliases)
end

function gitAutocomplete:generate(lineState)
	local alias = lineState:getword(2)
	if alias then
		if hasValue(branchLocalAliases, alias) then
			getBranchesLocal(alias) 
		elseif hasValue(branchRemoteAliases, alias) then
			getBranchesLocal(alias)
			getBranchesRemote(alias) 
		elseif hasValue(resetAliases, alias) then
			rebuildArgs()
		end
	end
end

rebuildArgs()
