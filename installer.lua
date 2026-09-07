local function installFile(name, url, force)
    if force and fs.exists(name) then
        fs.delete(name)
    end

    if not fs.exists(name) then
        shell.run("wget", url, name)
    end
end

local function installScript(dir, url)
    if not fs.exists(dir) then
        shell.run("wget", "run", url)
    end
end


installFile("recyclingAPI.lua",
    "https://raw.githubusercontent.com/SethGamer1223/recyclingAPI/refs/heads/main/recyclingAPI.lua",
    true)

installScript("ccryptolib",
    "https://github.com/migeyel/ccryptolib/releases/download/v1.2.2/install.lua")

installScript("ecnet2",
    "https://github.com/migeyel/ecnet/releases/download/v2.1.0/install.lua")

print("recyclingAPI has been installed!")
