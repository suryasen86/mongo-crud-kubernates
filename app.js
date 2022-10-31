const express=require('express')
const mongoose=require('mongoose')
const bodyParser = require('body-parser')
const app =express()

let mongoDbUrl=`mongodb+srv://qwerty12:qwerty12@cluster0.cedcr.mongodb.net/crudpractice?retryWrites=true&w=majority`

mongoose.connect(mongoDbUrl,{},()=>{
    console.log("mongodb connected")
})
app.use(bodyParser())
app.get('/',(req,res)=>{
    console.log(process.env.DEMO_GREETING)
    res.send(process.env.DEMO_GREETING)
})


app.use('/product',require('./routers/product'))

app.listen(3000,()=>{
    console.log("Running")
})
