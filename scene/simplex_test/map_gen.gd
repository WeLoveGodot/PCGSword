extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()
var base_height = 0.5
var noise_power = 0.5
var width_noise = 0.3

var working = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$working.visible = working

func make_map():
	var map_seed = $input_layout/seed_input.text
	# var seed = get_node("seed_input").text
	update_noise(map_seed)
	make_image()


func update_noise(map_seed):
	noise.seed = float(map_seed)
	noise.octaves = int($input_layout/octaves_slider.value)
	noise.lacunarity = $input_layout/lacunarity_slider.value
	noise.period = $input_layout/period_slider.value
	noise.persistence = $input_layout/persistence_slider.value

func make_image():
	working = true

	var image = Image.new()
	var width = 320
	image.create(width, width, false, Image.FORMAT_RGB8)
	image.lock()
	for w in range(0, width):
		for h in range(0, width):
			var th = int( (1 - base_height + noise.get_noise_2d(w, h * width_noise) * noise_power) * width )
			if (h > th):
				image.set_pixel(w, h, Color.black)
			else:
				image.set_pixel(w, h, Color.white)
	image.unlock()
	var it = ImageTexture.new()
	it.create_from_image(image, 3)
	$map_container/map_viewer.texture = it
	working = false

func _on_confirm_button_pressed():
	if !working:
		make_map()

func _on_random_button_pressed():
	if !working:
		var map_seed = randi()
		$input_layout/seed_input.text = String(map_seed)
		update_noise(map_seed)
		make_image()

func _on_octaves_slider_value_changed(value):
	$input_layout/Label/octaves_value.text = String(value)


func _on_lacunarity_slider_value_changed(value):
	$input_layout/Label2/lacunarity_value.text = String(value)


func _on_period_slider_value_changed(value):
	$input_layout/Label3/period_value.text = String(value)


func _on_persistence_slider_value_changed(value):
	$input_layout/Label4/persistence_value.text = String(value)


func _on_base_height_slider_value_changed(value):
	base_height = value
	$input_layout/Label5/base_height_value.text = String(value)


func _on_noise_power_slider_value_changed(value):
	noise_power = value
	$input_layout/Label6/noise_power_value.text = String(value)


func _on_width_noise_slider_value_changed(value):
	width_noise = value
	$input_layout/Label7/width_noise_value.text = String(value)