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

app.post("/items", (req, res) => {
    const data = req.body.JSON
    console.log(data);
    const items = require("./database.json")

    const newItems = [...items, {
        id: uuid(),
        title: "new item!!",
        subtitle: "subtitle"
    }]
    
    writeDatabaseFile(newItems)
})

app.delete("/items", (req, res) => {
    const id = req.query["id"]
    console.log(id);
    res.send(id)
})

app.put("/items", (req, res) => {
    const data = req.body.JSON
    console.log(data);
    const items = require("./database.json")

    const index = items.findIndex(({id}) => data["id"])

    Object.assign(items[index], data)

    writeDatabaseFile(items)

    res.send(items[index])
})

app.get("/items", (req, res) => {
    res.send(require("./database.json"))
})

app.listen(3000, () => {
    console.log("Server listening on 3000");
})