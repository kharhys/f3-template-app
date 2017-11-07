module.exports = (app) ->
    mongooseClient = app .get \mongooseClient
    { Schema } = mongooseClient
    schema = 
        author: type: Schema.Types.ObjectId, ref: \users, required: true 
        title: type: String, required: true
        text: type: String, required: true
    Post = new Schema schema, timestamps: true
    mongooseClient .model \Post Post