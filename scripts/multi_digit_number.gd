extends Node

var digit: AnimatedSprite2D
var digits: Array = []
@export var number = 0

func split_number_into_digits(given_number: int):
	var keep_going = true
	var digit_counting_number = given_number
	var digit_count = 1
	while (keep_going):
		digit_counting_number /= 10
		if (digit_counting_number < 1):
			keep_going = false
			break
		digit_count += 1
	
	var returned_digits = []
	for i in range(0, digit_count):
		var k = digit_count - (i + 1)
		var j = 10 ** k
		returned_digits.push_front(int(given_number / j))
		given_number = given_number % (j)
	return returned_digits

func set_number(given_number: int) -> void:
	number = given_number
	var given_digits = split_number_into_digits(given_number)
	while (len(digits) < len(given_digits)):
		var new_digit: AnimatedSprite2D = digits[len(digits) - 1].duplicate()
		new_digit.position.x -= 90
		add_child(new_digit)
		digits.append(new_digit)
	while (len(digits) > len(given_digits)):
		digits.pop_back().queue_free()
	for i in range(0, len(digits)):
		digits[i].animation = "%d" % given_digits[i]
	
func _enter_tree() -> void:
	digit = find_child("Digit")
	digits.append(digit)
	set_number(number)\
