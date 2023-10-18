extends Node2D

const scroll_speed = 2
const font_size = 72
var font = FontFile.new()
var font_variation
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
var textlines = Array()

class MyTextLine:
	var width = -1
	var x_pos = -1
	var y_pos = -1
	var label: Label = null

func _init():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1.0))
	var load_result = font.load_dynamic_font("assets/Trueno-wml2.otf")
	if load_result == OK:
		print("Succssfull loaded font file")
		font_variation = FontVariation.new()
		font_variation.set_base_font(font)
	else:
		printerr("Failed loading font file")

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = 0
	while get_child_count() < msg.size():
		#-- create the label and add to scene
		var label = Label.new();
		#-- Assign font to label; 
		# Since Godot 4.0, font sizes are no longer defined in the font itself 
		# but are instead defined in the node that uses the font.
		if font != null:
			label.add_theme_font_override("font", font_variation)
			label.add_theme_font_size_override("font_size", font_size)
		label.text = msg[n]
		label.visible = false
		
		label.set_position(Vector2(0, 0))
		add_child(label)
		
		#-- create textline object and add to array
		var text_line = MyTextLine.new()
		text_line.label = label
		textlines.append(text_line)
		n += 1

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var viewport_width = viewport_size.x
	var viewport_height = viewport_size.y
	var prev_line_offset = -1
	
	#-- Scroll text
	for n in msg.size():
		var text_line = textlines[n] as MyTextLine
		var text_label = text_line.label as Label
		if text_label.visible == false:
			if prev_line_offset < 0:
				prev_line_offset = viewport_height

			text_line.width = text_label.size.x
			var x_pos = viewport_width / 2 - text_line.width / 2
			var y_pos = prev_line_offset
			text_line.x_pos = x_pos
			text_line.y_pos = y_pos
			text_label.set_position(Vector2(x_pos, y_pos))
			text_label.visible = true
			prev_line_offset += font_size
		else:
			if text_line.y_pos > -(font_size * 2):
				text_line.y_pos -= scroll_speed
				text_label.set_position(Vector2(text_line.x_pos, text_line.y_pos))
				
	#-- Reset text scrolling, when last line is done
	var last_line = textlines[msg.size() - 1] as MyTextLine
	if last_line.y_pos <= -(font_size):
		prev_line_offset = viewport_height
		for n in msg.size():
			var text_line = textlines[n] as MyTextLine
			text_line.y_pos = prev_line_offset
			prev_line_offset += font_size
