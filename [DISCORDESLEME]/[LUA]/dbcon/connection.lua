local db 

addEventHandler('onResourceStart', resourceRoot, function()
    db = dbConnect('sqlite', ':/main_erp.db')
end)

function getCon()
    return db
end 
