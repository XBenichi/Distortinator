extends Control

var layer = {
	"node": null,
	"name": "Layer",
	"image": null,
	"opacity": 255,
	"horizontal_distortion": 0.0,
	"vertical_distortion": 0.0,
	"amplitudeX": 0.0,
	"amplitudeY": 0.0,
	"frequencyX": 1,
	"frequencyY": 1,
	"scale": 0.0,
	"moveX": 0.0,
	"moveY": 0.0,
	"ping_pong": false,
	"palette_shifting_speed": 0,
	"palette": null,
	"palette_shifting": false,
	"interleaved":false,
	"interleaved_amplitudeX":0.0,
	"interleaved_amplitudeY":0.0,
	"interleaved_frequencyX":0.0,
	"interleaved_frequencyY":0.0,
	"interleaved_scale":0.0,
	"fisheye": false,
	"fisheyeX": 0.0,
	"fisheyeY": 0.0,
	"fisheyescale": 0.0,
	"fisheyeeffect": 0.0,
}

var currentLayerIndex = -1
var currentLayer = null

var layers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title("Distortinator 1.4")
	
	$TabContainer/Layer/LineEdit.editable = false
	for sliders in get_tree().get_nodes_in_group("sliders"):
		sliders.editable = false
	for checks in get_tree().get_nodes_in_group("checks"):
		checks.disabled = true
	for buttons in get_tree().get_nodes_in_group("buttons"):
		buttons.disabled = true
	for lines in get_tree().get_nodes_in_group("lines"):
		lines.editable = false
	
	
	


func _process(delta):
	$Panel/Label.text = ("FPS:" + var2str(Engine.get_frames_per_second()))


func _on_imageOpen_pressed():
	$TabContainer/Layer/LineEdit/FileDialog.popup()
	


func _on_FileDialog_file_selected(path):
	var image = Image.new()
	var image_texture = ImageTexture.new()
	image.load(path)
	image_texture.create_from_image(image)
	image_texture.set_flags(2)
	currentLayer.texture = image_texture
	layers[currentLayerIndex].image = var2str(image_texture)
	$TabContainer/Layer/TextureRect.texture = image_texture
	print(Vector2($TabContainer/Layer/TextureRect.texture.get_size().x,$TabContainer/Layer/TextureRect.texture.get_size().y))
	currentLayer.material.set("shader_param/screen_height",$TabContainer/Layer/TextureRect.texture.get_size().y)
	currentLayer.material.set("shader_param/screen_width",$TabContainer/Layer/TextureRect.texture.get_size().x)
	

func _on_AmpXSlider_value_changed(value):
	currentLayer.material.set("shader_param/amplitude",Vector2(value,$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider.value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/amplitude")
	layers[currentLayerIndex].amplitudeX = vec2.x
	
func _on_ampYSlider_value_changed(value):
	currentLayer.material.set("shader_param/amplitude",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/amplitude")
	layers[currentLayerIndex].amplitudeY = vec2.y


func _on_XCheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/horizontal_distortion")
	if onoff == false:
		currentLayer.material.set("shader_param/horizontal_distortion",true)
	else:
		currentLayer.material.set("shader_param/horizontal_distortion",false)
	
	layers[currentLayerIndex].horizontal_distortion = currentLayer.material.get("shader_param/horizontal_distortion")
	
	


func _on_VDXCheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/vertical_distortion")
	if $TabContainer/Distortion/ScrollContainer/VBoxContainer/Vdistort/XCheckBox.pressed == true:
		if onoff == 0 or onoff == 2:
			currentLayer.material.set("shader_param/vertical_distortion",1)
	else:
		currentLayer.material.set("shader_param/vertical_distortion",0)
	
	layers[currentLayerIndex].vertical_distortion = currentLayer.material.get("shader_param/vertical_distortion")



func _on_VDYCheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/vertical_distortion")
	if $TabContainer/Distortion/ScrollContainer/VBoxContainer/Vdistort/YCheckBox2.pressed == true:
		if onoff == 0 or onoff == 1:
			currentLayer.material.set("shader_param/vertical_distortion",2)
	else:
		currentLayer.material.set("shader_param/vertical_distortion",0)
	
	layers[currentLayerIndex].vertical_distortion = currentLayer.material.get("shader_param/vertical_distortion")
	





func _on_frqXSlider_value_changed(value):
	currentLayer.material.set("shader_param/frequency",Vector2(value,$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider.value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/frequency")
	layers[currentLayerIndex].frequencyX = vec2.x
	
func _on_frqYSlider_value_changed(value):
	currentLayer.material.set("shader_param/frequency",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/frequency")
	layers[currentLayerIndex].frequencyY = vec2.y

func _on_Slider_value_changed(value):
	currentLayer.material.set("shader_param/scale",value)
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Scale/Slider/LineEdit.value = value
	layers[currentLayerIndex].scale = currentLayer.material.get("shader_param/scale")

func _on_Opacity_value_changed(value):
	currentLayer.modulate.a = value
	$TabContainer/Layer/Opacity/Slider/LineEdit.value = value
	layers[currentLayerIndex].opacity = value

func _on_AlphaLineEdit_value_changed(value):
	$TabContainer/Layer/Opacity/Slider/.value = value


func _on_itlXcheck_pressed():
	var onoff = currentLayer.material.get("shader_param/interleaved")
	if $TabContainer/Distortion/ScrollContainer/VBoxContainer/Interleaved/Xcheck.pressed == true:
		currentLayer.material.set("shader_param/interleaved",1)
		layers[currentLayerIndex].interleaved = true
	else:
		currentLayer.material.set("shader_param/interleaved",0)
		layers[currentLayerIndex].interleaved = false
	
	



func _on_mveXSlider_value_changed(value):
	currentLayer.material.set("shader_param/move",Vector2(value,$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/move")
	layers[currentLayerIndex].moveX = vec2.x

func _on_moveYSlider_value_changed(value):
	currentLayer.material.set("shader_param/move",Vector2($TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value,value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/move")
	layers[currentLayerIndex].moveY = vec2.y

func _on_palSlider_value_changed(value):
	currentLayer.material.set("shader_param/palette_shifting_speed",value)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSpd/Slider/LineEdit.value = value
	layers[currentLayerIndex].palette_shifting_speed = currentLayer.material.get("shader_param/palette_shifting_speed")

func _on_CheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/ping_pong")
	if $TabContainer/Effects/ScrollContainer/VBoxContainer/Ping/CheckBox.pressed == true:
		currentLayer.material.set("shader_param/ping_pong",1)
		layers[currentLayerIndex].ping_pong = true
	else:
		currentLayer.material.set("shader_param/ping_pong",0)
		layers[currentLayerIndex].ping_pong = false



func _on_palCheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/palette_shifting")
	if $TabContainer/Effects/ScrollContainer/VBoxContainer/PalSft/CheckBox.pressed == true:
		currentLayer.material.set("shader_param/palette_shifting",1)
		layers[currentLayerIndex].palette_shifting = true
	else:
		currentLayer.material.set("shader_param/palette_shifting",0)
		layers[currentLayerIndex].palette_shifting = false
	



func _on_ampxLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value = value

	


func _on_ampyLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider.value = value


func _on_freqxLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value = value


func _on_freqyLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider.value = value

func _on_LineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Scale/Slider.value = value



func _on_moveLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value = value


func _on_moveyLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value = value


func _on_palLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSpd/Slider.value = value
	
	


func _on_palButton_pressed():
	$TabContainer/Effects/palFileDialog.popup()


func _on_palFileDialog_file_selected(path):
	var image = Image.new()
	var image_texture = ImageTexture.new()
	image.load(path)
	image_texture.create_from_image(image)
	image_texture.set_flags(2)
	currentLayer.material.set("shader_param/palette",image_texture)
	layers[currentLayerIndex].palette = var2str(image_texture)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Pal/TextureRect.texture = image_texture
	





func _on_New_pressed():
	currentLayerIndex = currentLayerIndex + 1
	layers.append(layer.duplicate())
	if layers[currentLayerIndex].node == null:
		var node = load("res://Nodes/bg.tscn")
		var textNode = node.instance()
		#textNode.material.set("shader_param/frequency",Vector2(1,1))
		textNode.material = textNode.material.duplicate()
		currentLayer = null
		$ColorRect/ViewportContainer/Viewport.add_child(textNode)
		currentLayer = textNode
		for sliders in get_tree().get_nodes_in_group("sliders"):
			sliders.value = 0
			if sliders.editable == false:
				sliders.editable = true
				if $TabContainer/Layer/LineEdit.editable == false:
					$TabContainer/Layer/LineEdit.editable = true
		for checks in get_tree().get_nodes_in_group("checks"):
			checks.pressed = false
			if checks.disabled == true:
				checks.disabled = false
		for buttons in get_tree().get_nodes_in_group("buttons"):
			if buttons.disabled == true:
				buttons.disabled = false
		for lines in get_tree().get_nodes_in_group("lines"):
			if lines.editable == false:
				lines.editable = true
		$TabContainer/Layer/LineEdit.text = ("Layer " + var2str(currentLayerIndex))
		$TabContainer/Layer/TextureRect.texture = null
		$TabContainer/Layer/Opacity/Slider.value = 1
		$TabContainer/Layer/Opacity/Slider.editable = true
		$ItemList.add_item($TabContainer/Layer/LineEdit.text)
		$TabContainer/Effects/ScrollContainer/VBoxContainer/Pal/TextureRect.texture = null
		

		
		layers[currentLayerIndex].name = ("Layer " + var2str(currentLayerIndex))
		layers[currentLayerIndex].node = currentLayer

func changeLayer():
	currentLayer = layers[currentLayerIndex].node
	
	$TabContainer/Layer/Opacity/Slider.value = layers[currentLayerIndex].opacity
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value = layers[currentLayerIndex].amplitudeX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider.value = layers[currentLayerIndex].amplitudeY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value = layers[currentLayerIndex].frequencyX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider.value = layers[currentLayerIndex].frequencyY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Scale/Slider.value = layers[currentLayerIndex].scale
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value = layers[currentLayerIndex].moveX
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value = layers[currentLayerIndex].moveY
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSpd/Slider.value = layers[currentLayerIndex].palette_shifting_speed
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Ping/CheckBox.pressed = layers[currentLayerIndex].ping_pong
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSft/CheckBox.pressed = layers[currentLayerIndex].palette_shifting
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Brl/CheckBox.pressed = layers[currentLayerIndex].fisheye
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value = layers[currentLayerIndex].fisheyeX
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value = layers[currentLayerIndex].fisheyeY
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider.value = layers[currentLayerIndex].fisheyeeffect
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider.value = layers[currentLayerIndex].fisheyescale
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IScale/Slider.value = layers[currentLayerIndex].interleaved_scale
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider.value = layers[currentLayerIndex].interleaved_frequencyY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider.value = layers[currentLayerIndex].interleaved_frequencyX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider.value = layers[currentLayerIndex].interleaved_amplitudeX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider.value = layers[currentLayerIndex].interleaved_amplitudeY
	
	if layers[currentLayerIndex].image != null:
		$TabContainer/Layer/TextureRect.texture = str2var(layers[currentLayerIndex].image)
		if layers[currentLayerIndex].palette != null:
			$TabContainer/Effects/ScrollContainer/VBoxContainer/Pal/TextureRect.texture = str2var(layers[currentLayerIndex].palette)
			currentLayer.material.set("shader_param/palette",str2var(layers[currentLayerIndex].palette))
	$TabContainer/Layer/LineEdit.text = layers[currentLayerIndex].name
	
func _on_LineEdit_text_changed(new_text):
	layers[currentLayerIndex].name = new_text
	#$Tree.get_child(currentLayerIndex).set_text(0,new_text)
	$ItemList.set_item_text(currentLayerIndex,new_text)


func _on_NewBG_pressed():
	$HBoxContainer/NewBG/ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	for n in $ColorRect/ViewportContainer/Viewport.get_children():
		$ColorRect/ViewportContainer/Viewport.remove_child(n)
		n.queue_free()
		$ItemList.clear()
		layers.clear()
		currentLayer = null
		currentLayerIndex = -1
		$TabContainer/Layer/LineEdit.editable = false
		for sliders in get_tree().get_nodes_in_group("sliders"):
			sliders.editable = false
			sliders.value
		for checks in get_tree().get_nodes_in_group("checks"):
			checks.disabled = true
		for buttons in get_tree().get_nodes_in_group("buttons"):
			buttons.disabled = true
		for lines in get_tree().get_nodes_in_group("lines"):
			lines.editable = false


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open_compressed(path,2,3)
	f.store_string(var2str(layers))
	f.close()


func _on_OpenFileDialog_file_selected(path):
	var f = File.new()
	f.open_compressed(path,1,3)
	var json = f.get_as_text()
	layers = str2var(json)
	createBackground()
	f.close()


func createBackground():
	for n in $ColorRect/ViewportContainer/Viewport.get_children():
		$ColorRect/ViewportContainer/Viewport.remove_child(n)
		n.queue_free()
		$ItemList.clear()
		layers.clear()
		currentLayer = null
		currentLayerIndex = -1
	for layerr in layers:
		currentLayerIndex = currentLayerIndex + 1
		var node = load("res://Nodes/bg.tscn")
		var textNode = node.instance()
		#textNode.material.set("shader_param/frequency",Vector2(1,1))
		textNode.material = textNode.material.duplicate()
		currentLayer = null
		
		$ColorRect/ViewportContainer/Viewport.add_child(textNode)
		currentLayer = textNode
		for sliders in get_tree().get_nodes_in_group("sliders"):
			sliders.value = 0
			if sliders.editable == false:
				sliders.editable = true
		for checks in get_tree().get_nodes_in_group("checks"):
			checks.pressed = false
			if checks.disabled == true:
				checks.disabled = false
		for buttons in get_tree().get_nodes_in_group("buttons"):
			if buttons.disabled == true:
				buttons.disabled = false
		for lines in get_tree().get_nodes_in_group("lines"):
			if lines.editable == false:
				lines.editable = true
		$TabContainer/Layer/LineEdit.text = layers[currentLayerIndex].name
		$TabContainer/Layer/TextureRect.texture = null
		$TabContainer/Layer/Opacity/Slider.value = 1
		$TabContainer/Layer/Opacity/Slider.editable = true
		$ItemList.add_item($TabContainer/Layer/LineEdit.text)
		#treelayer = $Tree.create_item(root)
		#treelayer.set_text(0, $TabContainer/Layer/LineEdit.text)

		
		
		#layers[currentLayerIndex].name = ("Layer " + var2str(currentLayerIndex))
		layers[currentLayerIndex].node = currentLayer
		
		$TabContainer/Layer/Opacity/Slider.value = layers[currentLayerIndex].opacity
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value = layers[currentLayerIndex].amplitude.x
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider.value = layers[currentLayerIndex].amplitude.y
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value = layers[currentLayerIndex].frequency.x
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider.value = layers[currentLayerIndex].frequency.y
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/Scale/Slider.value = layers[currentLayerIndex].scale
		$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value = layers[currentLayerIndex].move.x
		$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value = layers[currentLayerIndex].move.y
		$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSpd/Slider.value = layers[currentLayerIndex].palette_shifting_speed
		$TabContainer/Effects/ScrollContainer/VBoxContainer/Ping/CheckBox.pressed = layers[currentLayerIndex].ping_pong
		$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSft/CheckBox.pressed = layers[currentLayerIndex].palette_shifting
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/IScale/Slider.value = layers[currentLayerIndex].interleaved_scale
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider.value = layers[currentLayerIndex].interleaved_frequency.y
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider.value = layers[currentLayerIndex].interleaved_frequency.x
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider.value = layers[currentLayerIndex].interleaved_amplitude.x
		$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider.value = layers[currentLayerIndex].interleaved_amplitude.y
		if layers[currentLayerIndex].image != null:
			textNode.texture = str2var(layers[currentLayerIndex].image)
			$TabContainer/Layer/TextureRect.texture = str2var(layers[currentLayerIndex].image)
			if layers[currentLayerIndex].palette != null:
				$TabContainer/Effects/ScrollContainer/VBoxContainer/Pal/TextureRect.texture = str2var(layers[currentLayerIndex].palette)
		$TabContainer/Layer/LineEdit.text = layers[currentLayerIndex].name




#func _on_Open_pressed():
	#$FileDialog2.popup()


func _on_Save_pressed():
	$FileDialog.popup()


func _on_Remove_pressed():
	var n = layers[currentLayerIndex].node
	$ColorRect/ViewportContainer/Viewport.remove_child(n)
	n.queue_free()
	layers.remove(currentLayerIndex)
	$ItemList.remove_item(currentLayerIndex)
	currentLayerIndex = currentLayerIndex - 1
	currentLayer = layers[currentLayerIndex].node
	#$Tree.get_selected().get_parent().remove_child($Tree.get_selected())
	$TabContainer/Layer/Opacity/Slider.value = layers[currentLayerIndex].opacity
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value = layers[currentLayerIndex].amplitudeX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider.value = layers[currentLayerIndex].amplitudeY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value = layers[currentLayerIndex].frequencyX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider.value = layers[currentLayerIndex].frequencyY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Scale/Slider.value = layers[currentLayerIndex].scale
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value = layers[currentLayerIndex].moveX
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value = layers[currentLayerIndex].moveY
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSpd/Slider.value = layers[currentLayerIndex].palette_shifting_speed
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Ping/CheckBox.pressed = layers[currentLayerIndex].ping_pong
	$TabContainer/Effects/ScrollContainer/VBoxContainer/PalSft/CheckBox.pressed = layers[currentLayerIndex].palette_shifting
	$TabContainer/Layer/LineEdit.text = layers[currentLayerIndex].name
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Brl/CheckBox.pressed = layers[currentLayerIndex].fisheye
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value = layers[currentLayerIndex].fisheyeX
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value = layers[currentLayerIndex].fisheyeY
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider.value = layers[currentLayerIndex].fisheyeeffect
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider.value = layers[currentLayerIndex].fisheyescale
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IScale/Slider.value = layers[currentLayerIndex].interleaved_scale
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider.value = layers[currentLayerIndex].interleaved_frequencyY
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider.value = layers[currentLayerIndex].interleaved_frequencyX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider.value = layers[currentLayerIndex].interleaved_amplitudeX
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider.value = layers[currentLayerIndex].interleaved_amplitudeY
func _on_ItemList_item_selected(index):
	for i in layers.size():
		if layers[i].name == $ItemList.get_item_text(index):
			if currentLayerIndex != i:
				currentLayerIndex = i
				changeLayer()
				

func _on_FECheckBox_pressed():
	var onoff = currentLayer.material.get("shader_param/barrel")
	if $TabContainer/Effects/ScrollContainer/VBoxContainer/Brl/CheckBox.pressed == true:
		currentLayer.material.set("shader_param/barrel",1)
		layers[currentLayerIndex].fisheye = true
	else:
		currentLayer.material.set("shader_param/barrel",0)
		layers[currentLayerIndex].fisheye = false


func _on_FEPOSXSlider_value_changed(value):
	currentLayer.material.set("shader_param/barrelxy",Vector2(value,$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/barrelxy")
	layers[currentLayerIndex].fisheyeX = vec2.x


func _on_FEPOSYSlider_value_changed(value):
	currentLayer.material.set("shader_param/barrelxy",Vector2($TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value,value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/barrelxy")
	layers[currentLayerIndex].fisheyeY = vec2.y
func _on_FEESlider_value_changed(value):
	currentLayer.material.set("shader_param/effect",value)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider/LineEdit.value = value
	layers[currentLayerIndex].fisheyeeffect = currentLayer.material.get("shader_param/effect")


func _on_IAMPXSlider_value_changed(value):
	currentLayer.material.set("shader_param/i_amplitude",Vector2(value,$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider.value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/i_amplitude")
	layers[currentLayerIndex].interleaved_amplitudeX = vec2.x
	
func _on_IAMPYSlider_value_changed(value):
	currentLayer.material.set("shader_param/i_amplitude",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/i_amplitude")
	layers[currentLayerIndex].interleaved_amplitudeY = vec2.y

func _on_IFREQXSlider_value_changed(value):
	currentLayer.material.set("shader_param/i_frequency",Vector2(value,$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider.value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/i_frequency")
	layers[currentLayerIndex].interleaved_frequencyX = vec2.x



func _on_IFREQYSlider_value_changed(value):
	currentLayer.material.set("shader_param/i_frequency",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider/LineEdit.value = value
	var vec2 = currentLayer.material.get("shader_param/i_frequency")
	layers[currentLayerIndex].interleaved_frequencyY = vec2.y

func _on_ISSlider_value_changed(value):
	currentLayer.material.set("shader_param/i_scale",value)
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IScale/Slider/LineEdit.value = value
	layers[currentLayerIndex].interleaved_scale = currentLayer.material.get("shader_param/i_scale")

func _on_FESSlider_value_changed(value):
	currentLayer.material.set("shader_param/effect_scale",value)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider/LineEdit.value = value
	layers[currentLayerIndex].fisheyescale = currentLayer.material.get("shader_param/effect_scale")



func _on_FEPOSLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value = value


func _on_FEPOSYLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value = value


func _on_FEELineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider.value = value


func _on_FESLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider.value = value

func _on_ISLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IScale/Slider.value = value


func _on_IFYLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/YSlider.value = value


func _on_IFXLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IFreq/XSlider.value = value


func _on_IAYLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/YSlider.value = value


func _on_IAXLineEdit_value_changed(value):
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/IAmp/XSlider.value = value
