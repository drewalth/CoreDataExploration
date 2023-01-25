const {v4: uuid} = require("uuid")
const app = require("express")()
const fs = require("fs")

const writeDatabaseFile = (items, callback = undefined) => {
    let data = JSON.stringify(items, null, 2)

    fs.writeFile("./database.json", data, () => {
        console.log("database file written");
        callback && callback()
    })

}

let database = require("./database.json")

app.use(require("express").json())

app.post("/items", (req, res) => {
    const newItem = req.body
    const newItems = [...database, newItem]
    
    writeDatabaseFile(newItems)

    database = newItems

    res.send(newItem)
})

app.get("/items", (req, res) => {
    res.send(database)
})

app.listen(3000, () => {
    console.log("Server listening on 3000");
})