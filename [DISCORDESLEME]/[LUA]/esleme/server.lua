local db = exports["dbcon"]:getCon()
users = {}

function kodOlustur()
    local res = ""
    length = 12
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return string.upper(res)
end

addEventHandler('onResourceStart', resourceRoot, function()

    dbQuery(function(qH)
        
        local results = dbPoll(qH, 0)
        for k, v in pairs(results) do 
            table.insert(users, {kod=v.code, userid=v.userid, userdcname=v.userdcname, mtaacname=v.mtaacname, mtaname=v.mtaname})
        end 

    end, db, 'SELECT * FROM hesapesleme')

end)

function koduVar(targetP)
    for k, v in pairs(users) do 
        if v.mtaacname == getElementData(targetP, 'account:username') then 
            return true
        end 
    end 
end

function getCode(p)
    for k, v in pairs(users) do 
        if v.mtaacname == getElementData(p, 'account:username') then 
            return v.kod
        end
    end     
end 

function isEsledi(p)
    for k, v in pairs(users) do 
        if v.mtaacname == getElementData(p, 'account:username') then 
            if string.len(tostring(v.userid)) >= 5 then 
                return true
            end 
        end 
    end 
end     

function getUserIdentify(user)
    for k, v in pairs(users) do 
        if v.mtaacname == getElementData(p, 'account:username') then 
            return {v.userdcname, v.userid}
        end 
    end 
end 

addCommandHandler('dcesle', function(pl, cmd)
    local kod 
    restartResource(getThisResource())
    if not koduVar(pl) == true then 
        kod = kodOlustur()
        dbExec(db, 'INSERT INTO hesapesleme(code, userid, userdcname, mtaacname, mtaname) VALUES(?, ?, ?, ?, ?)', kod, "", "", getElementData(pl, 'account:username'), getPlayerName(pl))
        table.insert(users, {kod=kod, userid="", userdcname="", mtaacname=getElementData(pl, 'account:username'), mtaname=getPlayerName(pl)})
    else 
        kod = getCode(pl)
    end 
    outputChatBox('#0000FF[!] #FFFFFFDiscord kodunuz : ' .. kod, pl, 0, 255, 0, true)

end)

function async_reload(player)
    dbQuery(function(qH)
    
        local results = dbPoll(qH, 0)
        local names = {}
        for k, v in pairs(results) do 
            table.insert(names, v.mtaacname)
        end 
        if names[getElementData(player, 'account:username')] then
            for k, v in pairs(results) do 
                if v.mtaacname == getElementData(player, 'account:username') then 
                    setElementData(player, 'gecici:isim', v.userdcname)
                    setElementData(player, 'gecici:id', v.userid)
                end 
            end 
        else 
            setElementData(player, 'gecici:isim', nil)
            setElementData(player, 'gecici:id', nil)
        end 
    end, db, 'SELECT * FROM hesapesleme')
end 

addCommandHandler('dcboz', function(pl, cmd)
    local query = dbQuery(function(qH)
    
        local results = dbPoll(qH, 0)
        for k, v in pairs(results) do 
            if getElementData(pl, 'account:username') == v.mtaacname then
                if string.len(v.userdcname) >= 2 then
                    outputChatBox('#0000FF[!] #FFFFFFDiscord hesabın başarıyla inentegre edildi.', pl, 0, 255, 0, true)
                    dbExec(db, 'DELETE FROM hesapesleme WHERE mtaacname = ?', getElementData(pl, 'account:username'))
                end
            end 
        end 

    end, db, 'SELECT * FROM hesapesleme')
end)


addCommandHandler('dchesabım', function(pl, cmd)
        local query = dbQuery(function(qH)
            local results = dbPoll(qH, 0)
            for k, v in pairs(results) do 
                if getElementData(pl, 'account:username') == v.mtaacname then 
                    dcname = v.userdcname
                    userid = v.userid
                    if dcname and userid then
                        outputChatBox('#0000FF[!] #FFFFFFKullanıcı Adı : ' .. dcname, pl, 0, 255, 0, true)
                        outputChatBox('#0000FF[!] #FFFFFFKullanıcı ID : ' .. userid, pl, 0, 255, 0, true)
                    else 
                        outputChatBox('#0000FF[!] #FFFFFFBunun için önce discord hesabını eşlemelisin, bunun için [/dcesle]', pl, 0, 255, 0, true)
                    end 
                end 
            end 
        end, db, 'SELECT * FROM hesapesleme')
        

end)