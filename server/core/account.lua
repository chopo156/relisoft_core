function getSharedAccount(account,cb)
    TriggerEvent('esx_addonaccount:getSharedAccount', account, function(account)
        cb(account)
    end)
end

exports('getSharedAccount',getSharedAccount)

function getAccount(owner,account,cb)
    TriggerEvent('esx_addonaccount:getAccount', account, owner, function(account)
        cb(account)
    end)
end

exports('getAccount',getAccount)

function isAccountExists(account)
    rdebug(string.format('Checking %s shared account if exists.', account))
    MySQL.ready(function()
        local data = MySQL.Sync.fetchAll('SELECT name FROM addon_account WHERE name = @name', {
            ['@name'] = name
        })
        if data[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end

exports('isAccountExists',isAccountExists)

function createAccount(account,shared,cb)
    isAccountExists(account,function(is)
        if is then
            rdebug(string.format('Account %s already exists! Skipping creation!',account))
        else
            rdebug(string.format('Account %s not found! Starting creation.', account))
            MySQL.ready(function()
                MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @name, @shared)', {
                    ['@name'] = account,
                    ['@shared'] = shared
                }, function(rowsChanges)
                    rdebug(string.format('Account %s created.', account))
                    cb(rowsChanges)
                end)
            end)
        end
    end)
end

exports('createAccount',createAccount)