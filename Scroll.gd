extends Node2D

const scroll_speed = 1;
const font_size = 84;
var font = DynamicFont.new()
var msg = [ 
	"Lorem ipsum dolor sit amet,",
	"consetetur sadipscing elitr,",
	"sed diam nonumy eirmod tempor",
	"invidunt ut labore et dolore",
	"magna aliquyam erat, sed diam",
	"voluptua. At vero eos et accusam",
	"et justo duo dolores et ea rebum.",
	"Stet clita kasd gubergren, no sea",
	"takimata sanctus est Lorem ipsum",
	"dolor sit amet. Lorem ipsum dolor",
	"sit amet, consetetur sadipscing elitr,",
	"sed diam nonumy eirmod tempor invidunt",
	"ut labore et dolore magna aliquyam erat,",
	"sed diam voluptua. At vero eos et",
	"accusam et justo duo dolores et ea",
	"rebum. Stet clita kasd gubergren, no",
	"sea takimata sanctus est Lorem ipsum",
	"dolor sit amet.",
	"****\n" 
]
var dict = {}

class TextLine:
	var width = -1
	var x_pos = -1
	var y_pos = -1
	var label: Label = null

func _init():
	VisualServer.set_default_clear_color(Color(0, 0, 0, 1.0))
	font.font_data = load("assets/Trueno-wml2.otf")
	font.size = font_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = 0
	while get_child_count() < msg.size():
		#-- create the label and add to scene
		var label = Label.new();
		label.add_font_override("font", font)
		label.text = msg[n]
		label.visible = false
		
		label.set_position(Vector2(0, 0))
		add_child(label)
		
		#-- create textline object and add to dictionary
		var text_line = TextLine.new()
		text_line.label = label
		dict[n] = text_line
		n += 1

func _draw():
	var viewport_size = get_viewport_rect().size
	var viewport_width = viewport_size.x
	var viewport_height = viewport_size.y

	var prev_line_offset = -1
	for n in msg.size():
		var text_line = dict[n] as TextLine
		var text_label = text_line.label as Label
		if text_label.visible == false:
			if prev_line_offset < 0:
				prev_line_offset = viewport_height

			text_line.width = text_label.rect_size.x
			var x_pos = viewport_width / 2 - text_line.width / 2
			var y_pos = prev_line_offset
			text_line.x_pos = x_pos
			text_line.y_pos = y_pos
			text_label.set_position(Vector2(x_pos, y_pos))
			text_label.visible = true
			prev_line_offset += font_size
		else:
			if text_line.y_pos > -(font_size):
				text_line.y_pos -= scroll_speed
				text_label.set_position(Vector2(text_line.x_pos, text_line.y_pos))

func _process(delta):
	update()
