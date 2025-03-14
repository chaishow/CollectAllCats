extends Label3D


var good_estimates = ['Круто', 'Молодец', 'Супер']
var bad_estimates = ['Ой', '.-.']

var ok = false

func _ready():
	$Timer.start()

func _process(delta):
	if ok:
		make_tranparent(delta)

func make_tranparent(delta):
	visible=false
	queue_free()

func _on_timer_timeout():
	ok = true
