local composer = require('composer')

native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

composer.gotoScene('scenes.menu')