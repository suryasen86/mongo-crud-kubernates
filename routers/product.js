const express = require('express')
const proDuctRouter = express.Router()
const Product = require('../models/product')
proDuctRouter.get('/', async (req, res) => {
    let products = await Product.find().sort({createdAt:-1})
    res.json(products,200)
})


proDuctRouter.post('/', async (req, res) => {
    try {
        let checkForExisting = await Product.findOne({
            name: req.body.name
        })
        if (checkForExisting) {
            return res.send("Product Name Exist")
        }
        let product = await Product.create(req.body)

        res.send(product)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }

})

proDuctRouter.delete('/:id', async (req, res) => {
    try {
        let product = await Product.findByIdAndUpdate(req.params.id, {
            is_active: false
        })

        if (!product) {
            return res.send("Invalid ID")
        }
        product = await Product.findById(req.params.id)
        res.send(product)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }

})

module.exports = proDuctRouter