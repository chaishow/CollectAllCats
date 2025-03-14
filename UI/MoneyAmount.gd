extends Label


func _ready():
	text = '0'



func _on_bank_money_amount_changed(amount):
	text = Utilies.scale_numb(amount)
