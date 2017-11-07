module.exports =
  email: type: String, required: true, unique: true,
#  password:  type: String, required: true ,
#  name:  type: String, required: false ,
  phone:  type: String, required: false ,
  product:  type: String, required: false ,
  createdAt:  type: Date, 'default': Date.now ,
  updatedAt:  type: Date, 'default': Date.now 
