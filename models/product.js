const mongoose=require('mongoose')

const productSchema=new mongoose.Schema({
    name:{
        type:String,
        required: true,
    },
    price:{
        type:Number,
        required:true
    }
    ,
    description:{
        type:String,
        required:true
    },
    is_active:{
        type:Boolean,
        required:false,
        default:true
    },
    createdAt:
    {
        type:Date,
        default:Date.now
    }
})


module.exports= mongoose.model('product',productSchema)