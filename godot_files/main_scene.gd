extends Control

# Hi everyone!
#
# Little tutorial for the best community : GODOT ENGINE FRANCOPHONE
#
# This code will show you the basic CRUD of database through http requests. CRUD
# means Create, Read, Update, Delete. If you already know this kind of stuff
# this tutorial is not for you but if you are just a curious fellow: welcome!
#
# There is no protection or limitation or security like blocking buttons or
# waiting for a response. This is not a tool but just a sandbox where you can do
# whatever you want.
#
# The idea here is that, when you do a request (whatever it is), the specific
# HTTPRequest node will emit a signal in return `request_completed`. This 
# result can be an error but don't worry. Just try things.

# --- PREFILLED ---

# Prefill url and apikey to avoid copy pasta each time you launch the tutorial 

@export var prefilled_url : String
@export var prefilled_apikey : String

# --- BUTTONS ---

@onready var button_get : Button = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/VBoxResults/ButtonGet
@onready var button_create : Button = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Create/MarginCreate/VBoxCreate/ButtonCreate
@onready var button_update_patch : Button = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Update/MarginUpdate/VBoxUpdate/ButtonUpdatePatch
@onready var button_delete : Button = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Delete/MarginDelete/VBoxDelete/ButtonDelete

# --- INPUT ---

# Setting
@onready var url : LineEdit = $MarginGeneral/VBoxGeneral/HBoxUrl/InputUrl
@onready var apikey : LineEdit = $MarginGeneral/VBoxGeneral/HBoxApikey/InputApikey
# Create
@onready var create_id : LineEdit = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Create/MarginCreate/VBoxCreate/HBoxCreateId/LineEditCreateId
@onready var create_a : LineEdit = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Create/MarginCreate/VBoxCreate/HBoxCreateA/LineEditCreateA
@onready var create_b : CheckBox = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Create/MarginCreate/VBoxCreate/HBoxCreateB/CheckCreateB
@onready var create_c : SpinBox = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Create/MarginCreate/VBoxCreate/HBoxCreateC/SpinBoxCreateC
# Update
@onready var update_id : LineEdit = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Update/MarginUpdate/VBoxUpdate/HBoxUpdateId/LineEditUpdateId
@onready var update_a : LineEdit = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Update/MarginUpdate/VBoxUpdate/HBoxUpdateA/LineEditUpdateA
@onready var update_b : CheckBox = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Update/MarginUpdate/VBoxUpdate/HBoxUpdateB/CheckUpdateB
@onready var update_c : SpinBox = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Update/MarginUpdate/VBoxUpdate/HBoxUpdateC/SpinBoxUpdateC
# Delete
@onready var delete_id : LineEdit = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/CUD/Delete/MarginDelete/VBoxDelete/HBoxDeleteId/LineEditDeleteId

# --- OTHERS ---

@onready var http : HTTPRequest = $HTTPRequest
@onready var console : RichTextLabel = $MarginGeneral/VBoxGeneral/MarginCRUD/HBoxCRUD/VBoxResults/Console

# --- THE COOOOOOODE ---

func _ready() -> void :
	# Buttons
	button_get.pressed.connect(on_get_pressed)
	button_create.pressed.connect(on_create_pressed)
	button_update_patch.pressed.connect(on_update_patch_pressed)
	button_delete.pressed.connect(on_delete_pressed)
	# http return
	http.request_completed.connect(on_request_completed)
	# prefill
	if !prefilled_url.is_empty() :
		url.text = prefilled_url
	if !prefilled_apikey.is_empty() :
		apikey.text = prefilled_apikey

# --- BUTTONS FUNCTIONS ---

## With this we send an http request to the url set on the top of the app with
## the apikey in the header if it exists. The header is additional parameters
## to provide to the server via the http request. Be careful, don't hardcode
## acces_token or security, don't be like AI code please! If no method is
## specified on http.request, it will be a "GET" method. 
func on_get_pressed() :
	if url.text.is_empty() :
		output_text("No url provided")
	else :
		if apikey.text.is_empty() :
			output_separator()
			output_text("Request (nokey) : " + url.text)
			http.request(url.text)
		else :
			output_separator()
			output_text("Request (apikey) : " + url.text)
			var header : PackedStringArray = ["apikey:"+apikey.text]
			http.request(url.text, header)

## Please provide url or nothing happens. First you need to construct your data
## in a Dictionary to give a JSON like for API, then you convert it in a String
## format (like RPC). In the end you send it with "POST" method.
func on_create_pressed() :
	if url.text.is_empty() or apikey.text.is_empty() :
		output_text("No url or apikey provided")
	else :
		var new_data : Dictionary = {
			"a" : create_a.text,
			"b" : create_b.button_pressed,
			"c" : int(create_c.value) # here i force int because i choose int2
			}
		var json = JSON.stringify(new_data)
		output_separator()
		output_text("New form requested")
		var header : PackedStringArray = ["apikey:"+apikey.text]
		http.request(url.text, header, HTTPClient.METHOD_POST, json)

## Update is more trickier, we need to know the id of the row to update it. You
## can do a request to your base to get the correct id. Here we just suppose
## that you know it. If you don't, you can push the button get. When you get the
## id you filter the request on it with `?id=eq.`
##
## Two method exist to update a row, PUT and PATCH :
## * PUT: completely replaces the row, you need the good format
## * PATCH: partially updates the row with given values, just the specified part
func on_update_patch_pressed() :
	if url.text.is_empty() or apikey.text.is_empty() :
		output_text("No url or apikey provided")
	else :
		if update_id.text.is_empty() :
			output_text("Need id to update")
		else :
			var url_update : String = url.text + "?id=eq." + update_id.text
			var new_data : Dictionary = {
				"a" : update_a.text,
				"b" : update_b.button_pressed,
				"c" : int(update_c.value) # here i force int because i choose int2
				}
			var json = JSON.stringify(new_data)
			output_separator()
			output_text("Update on " + url_update)
			var header : PackedStringArray = ["apikey:"+apikey.text]
			http.request(url_update, header, HTTPClient.METHOD_PATCH, json)

## Delete is easy... so this is dangerous. You just have to filter your request
## the use "DELETE" method. Like update, we do that with `?id=eq.`.
func on_delete_pressed() :
	if url.text.is_empty() or apikey.text.is_empty() :
		output_text("No url or apikey provided")
	else :
		if delete_id.text.is_empty() :
			output_text("Need id to delete")
		else :
			var url_update : String = url.text + "?id=eq." + delete_id.text
			output_separator()
			output_text("Update on " + url_update)
			var header : PackedStringArray = ["apikey:"+apikey.text]
			http.request(url_update, header, HTTPClient.METHOD_DELETE)

# --- OUTPUT ---

## Used when a request is completed.
## result and header is only need if you get some error or some deeper debugging
## to do. I mean, you can print them but this is not necessary. Response is the
## code that server send to you when you do a request. You know 404 ? This is
## a good exemple, we whant this to be ~200 (thats mean ok). If you got an error
## you will see it here.
@warning_ignore("unused_parameter")
func on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	# output_text("Result   : " + str(result))
	output_text("Response <" + str(response_code)+ ">")
	# output_text("Header   : " + str(headers))
	
	# This is the Body part, if there is one body it will output it
	# If you dont know json this is like gdscript Dictionary but not J. Statham
	if body :
		var json = JSON.parse_string(body.get_string_from_utf8())
		output_text("Body     :")
		output_text(str(json))

## Put a new line in the console, this is kind of an output or print function
## directly in the application because I can do that, and this is marvellous.
func output_text(text : String = "") -> void :
	console.newline()
	console.add_text(text)

func output_separator() :
	console.newline()
	console.add_text("\n --- \n")
