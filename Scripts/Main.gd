extends Control

var layer = {
	"node": null,
	"name": "Layer",
	"image": null,
	"opacity": 255,
	"horizontal_distortion": 0.0,
	"vertical_distortion": 0.0,
	"amplitude": Vector2(0,0),
	"frequency": Vector2(1,1),
	"scale": 0.0,
	"move": Vector2(0,0),
	"ping_pong": false,
	"palette_shifting_speed": 0,
	"palette": null,
	"palette_shifting": false,
	"Xinterleaved":false,
	"Yinterleaved":false,
}

var currentLayerIndex = -1
var currentLayer = null

var layers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title("Distortinator 1.0")
	
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
	layers[currentLayerIndex].amplitude = currentLayer.material.get("shader_param/amplitude")

func _on_ampYSlider_value_changed(value):
	currentLayer.material.set("shader_param/amplitude",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Amp/YSlider/LineEdit.value = value
	layers[currentLayerIndex].amplitude = currentLayer.material.get("shader_param/amplitude")



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
	
	layers[currentLayerIndex].frequency = currentLayer.material.get("shader_param/frequency")

func _on_frqYSlider_value_changed(value):
	currentLayer.material.set("shader_param/frequency",Vector2($TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/XSlider.value,value))
	$TabContainer/Distortion/ScrollContainer/VBoxContainer/Freq/YSlider/LineEdit.value = value
	layers[currentLayerIndex].frequency = currentLayer.material.get("shader_param/frequency")


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
		if onoff == 0 or onoff == 2:
			currentLayer.material.set("shader_param/interleaved",1)
			layers[currentLayerIndex].Xinterleaved = true
	else:
		currentLayer.material.set("shader_param/interleaved",0)
		layers[currentLayerIndex].Xinterleaved = false
		layers[currentLayerIndex].Yinterleaved = false
	
	


func _on_itlYcheck_pressed():
	var onoff = currentLayer.material.get("shader_param/interleaved")
	if $TabContainer/Distortion/ScrollContainer/VBoxContainer/Interleaved/Ycheck.pressed == true:
		if onoff == 0 or onoff == 1:
			currentLayer.material.set("shader_param/interleaved",2)
			layers[currentLayerIndex].Yinterleaved = true
	else:
		currentLayer.material.set("shader_param/interleaved",0)
		layers[currentLayerIndex].Yinterleaved = false
		layers[currentLayerIndex].Xinterleaved = true
	


func _on_mveXSlider_value_changed(value):
	currentLayer.material.set("shader_param/move",Vector2(value,$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider.value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider/LineEdit.value = value
	layers[currentLayerIndex].move = currentLayer.material.get("shader_param/move")


func _on_moveYSlider_value_changed(value):
	currentLayer.material.set("shader_param/move",Vector2($TabContainer/Effects/ScrollContainer/VBoxContainer/Move/XSlider.value,value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/Move/YSlider/LineEdit.value = value
	layers[currentLayerIndex].move = currentLayer.material.get("shader_param/move")
	
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
		$ColorRect.add_child(textNode)
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
	for n in $ColorRect.get_children():
		$ColorRect.remove_child(n)
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
	for n in $ColorRect.get_children():
		$ColorRect.remove_child(n)
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
		
		$ColorRect.add_child(textNode)
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
	$ColorRect.remove_child(n)
	n.queue_free()
	layers.remove(currentLayerIndex)
	$ItemList.remove_item(currentLayerIndex)
	currentLayerIndex = currentLayerIndex - 1
	currentLayer = layers[currentLayerIndex].node
	#$Tree.get_selected().get_parent().remove_child($Tree.get_selected())
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
	$TabContainer/Layer/LineEdit.text = layers[currentLayerIndex].name


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
		layers[currentLayerIndex].palette_shifting = true
	else:
		currentLayer.material.set("shader_param/barrel",0)
		layers[currentLayerIndex].palette_shifting = false


func _on_FEPOSXSlider_value_changed(value):
	currentLayer.material.set("shader_param/barrelxy",Vector2(value,$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider/LineEdit.value = value
	layers[currentLayerIndex].barrelxy = currentLayer.material.get("shader_param/barrelxy")


func _on_FEPOSYSlider_value_changed(value):
	currentLayer.material.set("shader_param/barrelxy",Vector2($TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value,value))
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider/LineEdit.value = value
	layers[currentLayerIndex].barrelxy = currentLayer.material.get("shader_param/barrelxy")


func _on_FEESlider_value_changed(value):
	currentLayer.material.set("shader_param/effect",value)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider/LineEdit.value = value
	layers[currentLayerIndex].scale = currentLayer.material.get("shader_param/effect")



func _on_FESSlider_value_changed(value):
	currentLayer.material.set("shader_param/effect_scale",value)
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider/LineEdit.value = value
	layers[currentLayerIndex].scale = currentLayer.material.get("shader_param/effect_scale")

func _on_FEPOSLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/XSlider.value = value


func _on_FEPOSYLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEPos/YSlider.value = value


func _on_FEELineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEEfct/Slider.value = value


func _on_FESLineEdit_value_changed(value):
	$TabContainer/Effects/ScrollContainer/VBoxContainer/FEScale/Slider.value = value
