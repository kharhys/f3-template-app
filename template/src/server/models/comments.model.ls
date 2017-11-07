module.exports = (app) ->
    mongooseClient = app .get \mongooseClient
    { Schema } = mongooseClient
    schema = 
        author: type: Schema.Types.ObjectId, ref: \users, required: true 
        text: type: String, required: true
    Comment = new Schema schema, timestamps: true
    mongooseClient .model \Comment Comment