extends Node

#Item color lists
var flower_colors = {"red": Color(0.698039, 0.129412, 0.129412), "orange": Color(0.854902, 0.329412, 0.145098), "light purple": Color(0.8, 0.517647, 0.917647), "purple": Color(0.447603, 0.209351, 0.546875), "pink": Color(0.933333, 0.270588, 0.486275), "white": Color(1, 1, 1), "black": Color(0.141176, 0.137255, 0.160784)}
var shell_colors = {"red": Color(0.698039, 0.129412, 0.129412), "orange": Color(0.866667, 0.482353, 0.262745), "green": Color(0.188235, 0.596078, 0.258824), "blue": Color(0.262745, 0.568627, 0.929412), "purple": Color(0.65098, 0.372549, 0.764706), "white": Color(1, 1, 1), "gold": Color(0.901961, 0.760784, 0.305882)}
var metal_colors = {"silver": Color(0.752941, 0.752941, 0.752941), "gold": Color(0.909804, 0.709804, 0.164706)}
var pastry_colors = {"apple": Color(0.670588, 0.035294, 0.035294), "blueberry": Color(0.101961, 0.431373, 0.568627), "orange": Color(0.960784, 0.509804, 0.164706)}

var items = {"apple" : {"identifiers": ["food", "fruit"], "image": "res://art/items/food/apple.png", "crumb color": Color(0.670588, 0.035294, 0.035294)},
	"blueberry" : {"identifiers": ["food", "fruit", "blueberries"], "image": "res://art/items/food/blueberry.png", "crumb color": Color(0.101961, 0.431373, 0.568627)},
	"burger" : {"identifiers": ["food"], "image": "res://art/items/food/burger.png", "crumb color": Color(0.6, 0.364706, 0.094118)},
	"carrot" : {"identifiers": ["food", "vegtables"], "image": "res://art/items/food/carrot.png", "crumb color": Color(0.960784, 0.509804, 0.164706)},
	"cauliflower" : {"identifiers": ["food", "vegtables"], "image": "res://art/items/food/cauliflower.png", "crumb color": Color(0.94902, 0.929412, 0.858824)},
	"cheddar" : {"identifiers": ["food", "cheese"], "image": "res://art/items/food/cheddar.png", "crumb color": Color(0.929412, 0.780392, 0.243137)},
	"cookie" : {"identifiers": ["food", "sweets"], "image": "res://art/items/food/cookie.png", "crumb color": Color(0.501961, 0.317647, 0.133333)},
	"corn" : {"identifiers": ["food", "vegtables"], "image": "res://art/items/food/corn.png", "crumb color": Color(0.929412, 0.780392, 0.243137)},
	"donut" : {"identifiers": ["food", "pastries", "sweets"], "image": "res://art/items/food/donut.png", "crumb color": Color(0.741176, 0.478431, 0.215686), "color list": pastry_colors},
	"goat cheese" : {"identifiers": ["food", "cheese"], "image": "res://art/items/food/goat_cheese.png", "crumb color": Color(0.94902, 0.929412, 0.858824)},
	"honeycomb" : {"identifiers": ["food", "sweets"], "image": "res://art/items/food/honeycomb.png", "crumb color": Color(0.929412, 0.780392, 0.243137)},
	"muffin" : {"identifiers": ["food", "pastries", "sweets"], "image": "res://art/items/food/muffin.png", "crumb color": Color(0.741176, 0.478431, 0.215686), "color list": pastry_colors},
	"mushroom" : {"identifiers": ["food"], "image": "res://art/items/food/mushroom.png", "crumb color": Color(0.380392, 0.278431, 0.172549)},
	"orange" : {"identifiers": ["food", "fruit"], "image": "res://art/items/food/orange.png", "crumb color": Color(0.960784, 0.509804, 0.164706)},
	"stack of pancakes" : {"identifiers": ["food", "pancakes"], "image": "res://art/items/food/pancakes.png", "crumb color": Color(0.901961, 0.752941, 0.403922)},
	"pear" : {"identifiers": ["food", "fruit"], "image": "res://art/items/food/pear.png", "crumb color": Color(0.709804, 0.85098, 0.466667)},
	"pie" : {"identifiers": ["food", "pastries", "sweets"], "image": "res://art/items/food/pie.png", "crumb color": Color(0.741176, 0.478431, 0.215686), "color list": pastry_colors},
	"pizza" : {"identifiers": ["food"], "image": "res://art/items/food/pizza.png", "crumb color": Color(0.929412, 0.780392, 0.243137)},
	"pretzel" : {"identifiers": ["food"], "image": "res://art/items/food/pretzel.png", "crumb color": Color(0.521569, 0.298039, 0.07451)},
	"radish" : {"identifiers": ["food", "vegtables"], "image": "res://art/items/food/radish.png", "crumb color": Color(0.941176, 0.917647, 0.901961)},
	"shrimp" : {"identifiers": ["food", "seafood"], "image": "res://art/items/food/shrimp.png", "crumb color": Color(0.941176, 0.623529, 0.443137)},
	"soda" : {"identifiers": ["food"], "image": "res://art/items/food/soda.png", "crumb color": Color(0.501961, 0.317647, 0.133333)},
	"squid" : {"identifiers": ["food", "seafood"], "image": "res://art/items/food/squid.png", "crumb color": Color(0.94902, 0.929412, 0.858824)},
	"sushi" : {"identifiers": ["food", "seafood"], "image": "res://art/items/food/sushi.png", "crumb color": Color(0.94902, 0.929412, 0.858824)},
	"earring" : {"identifiers": ["head accessory", "earrings"], "image": "res://art/items/accessories/earring.png", "sprite sheet": "res://art/sprite_sheets/accessories/earring.png", "color list": metal_colors},
	"earrings" : {"identifiers": ["head accessory", "earrings"], "image": "res://art/items/accessories/earrings.png", "sprite sheet": "res://art/sprite_sheets/accessories/earrings.png", "color list": metal_colors},
	"nugget" : {"identifiers": ["holdable", "nuggets"], "image": "res://art/items/nugget.png", "color list": metal_colors},
	"wizard hat" : {"identifiers": ["head accessory", "hats"], "image": "res://art/items/accessories/wizard_hat.png", "sprite sheet": "res://art/sprite_sheets/accessories/wizard_hat.png"},
	"clover" : {"identifiers": ["head accessory"], "image": "res://art/items/clover.png", "sprite sheet": "res://art/sprite_sheets/accessories/clover.png"},
	"daisy" : {"identifiers": ["head accessory", "flowers", "daisies"], "image": "res://art/items/flowers/daisy.png", "sprite sheet": "res://art/sprite_sheets/accessories/daisy.png", "color list": flower_colors},
	"rose" : {"identifiers": ["head accessory", "flowers"], "image": "res://art/items/flowers/rose.png", "sprite sheet": "res://art/sprite_sheets/accessories/rose.png", "color list": flower_colors},
	"tulip" : {"identifiers": ["head accessory", "flowers"], "image": "res://art/items/flowers/tulip.png", "sprite sheet": "res://art/sprite_sheets/accessories/tulip.png", "color list": flower_colors},
	"lily pad" : {"identifiers": ["head accessory", "flowers", "hats"], "image": "res://art/items/flowers/lily_pad.png", "sprite sheet": "res://art/sprite_sheets/accessories/lily_pad.png"},
	"sneakers" : {"identifiers": ["accessory", "sneakers", "shoes"], "image": "res://art/items/accessories/sneakers.png", "sprite sheet": "res://art/sprite_sheets/accessories/shoes.png", "color list": flower_colors},
	"coral" : {"identifiers": ["holdable"], "image": "res://art/items/coral.png", "color list": shell_colors},
	"scallop shell" : {"identifiers": ["holdable", "shells"], "image": "res://art/items/scallop_shell.png", "color list": shell_colors},
	"spiral shell" : {"identifiers": ["head accessory", "shells"], "image": "res://art/items/spiral_shell.png", "sprite sheet": "res://art/sprite_sheets/accessories/spiral_shell.png", "color list": shell_colors},
	"starfish" : {"identifiers": ["accessory"], "image": "res://art/items/starfish.png", "sprite sheet": "res://art/sprite_sheets/accessories/starfish.png", "color list": shell_colors},
	"oyster shell" : {"identifiers": ["holdable", "shells"], "image": "res://art/items/oyster_shell.png"},
	"piece of kelp" : {"identifiers": ["holdable", "kelp"], "image": "res://art/items/kelp.png", "color list": shell_colors}}

var inventory = {"white daisy" : {"base item": "daisy", "quantity": 10, "color name": "white"}, "red spiral shell" : {"base item": "spiral shell", "quantity": 10, "color name": "red"}, "apple" : {"base item": "apple", "quantity": 1, "color name": null}}
#var inventory = {}
var state = "item_state"
