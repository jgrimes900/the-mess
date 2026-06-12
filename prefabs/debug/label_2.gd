extends Label

var sm64_large = {
	"rq" = "\u0100",
	"uq" = "\u0101",
	"coin" = "\u0102",
	"dot" = "\u0103",
	"up" = "\u0104",
	"down" = "\u0105",
	"left" = "\u0106",
	"right" = "\u0107",
	"A" = "\u0108",
	"B" = "\u0109",
	"C" = "\u010A",
	"Z" = "\u010B",
	"R" = "\u010C",
	".." = "\u010D",
	"^" = "\u010E",
	"fs" = "\u010F",
	"bs" = "\u0110",
	"hook" = "\u0111",
	")(" = "\u0112",
	"<->" = "\u0113",
	"true" = "\u0114",
	"false" = "\u0115"
}

func parce_string(str: String, codes: Dictionary, delim: String = "\\"):
	for key in codes:
		print(key)
		str = str.replace(delim+key, codes[key])
	return str

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = parce_string(text, sm64_large, "@")
