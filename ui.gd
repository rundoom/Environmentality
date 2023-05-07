extends CanvasLayer


var abbreviation = {
	1000_000_000: "B",
	1000_000: "M",
	1000: "K",
}

var text_template = "{0}{1}"
var old_pollution := 0:
	set(value):
		var out_text: String = ""
		for it in abbreviation.keys():
			if old_pollution >= it:
				out_text = text_template.format([str(float(old_pollution)/it).pad_decimals(3).left(5), abbreviation[it]])
				break
		if out_text.is_empty():
			out_text = (str(old_pollution)).pad_decimals(3).left(5)
			
		$PollutionMeter.text = str(out_text)
		old_pollution = value
		
		
var polution_tween: Tween
var tweening_interval: float
		
		
func _ready() -> void:
	tweening_interval = get_tree().get_first_node_in_group("world").pollution_tick

		
func set_tweening_interval(val: float):
	tweening_interval = val


func set_pollution(new_val: int):
	if polution_tween != null: polution_tween.stop()
		
	polution_tween = create_tween()
	polution_tween.tween_property(self, "old_pollution", new_val, tweening_interval)
