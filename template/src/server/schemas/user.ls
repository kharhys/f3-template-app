Schema = global.mongoose.Schema;
validatePattern = require('../utils/validate-pattern');

colors = <[ #1ABC9C #16A085 #2ECC71 #27AE60 #3498DB #2980B9 #34495E #EA4C88 #CA2C68 #9B59B6 #8E44AD #F1C40F #F39C12 #E74C3C #C0392B ]>

module.exports =
  bitbucketId:  type: String ,
  bitbucket:  type: Schema.Types.Mixed ,
  dropboxId:  type: String ,
  dropbox:  type: Schema.Types.Mixed ,
  facebookId:  type: String ,
  facebook:  type: Schema.Types.Mixed ,
  githubId:  type: String ,
  github:  type: Schema.Types.Mixed ,
  googleId:  type: String ,
  google:  type: Schema.Types.Mixed ,
  instagramId:  type: String ,
  instagram:  type: Schema.Types.Mixed ,
  linkedinId:  type: String ,
  linkedin:  type: Schema.Types.Mixed ,
  paypalId:  type: String ,
  paypal:  type: Schema.Types.Mixed ,
  spotifyId:  type: String ,
  spotify:  type: Schema.Types.Mixed ,
  email: type: String, required: true, unique: true,
  password:  type: String, required: true ,
  name:  type: String, required: false ,
  isEnabled:
    type: Boolean,
    'default': true
  ,
  role:
    required: true,
    type: String,
    trim: true,
    validate: validatePattern('isTitle')
  ,
  color:
    required: false,
    type: String,
    trim: true,
    enum: colors,
    default: -> colors[Math.floor(Math.random()*colors.length)]
  ,
  gender: type: String,
  dob: type: Date,
  createdAt:  type: Date, 'default': Date.now ,
  updatedAt:  type: Date, 'default': Date.now ,
  isVerified:  type: Boolean ,
  verifyToken:  type: String ,
  verifyExpires:  type: Date ,
  verifyChanges:  type: Object ,
  resetToken:  type: String ,
  resetExpires:  type: Date
