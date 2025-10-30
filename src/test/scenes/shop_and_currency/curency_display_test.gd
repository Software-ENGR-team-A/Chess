# GdUnit generated TestSuite
class_name CurencyDisplayTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scenes/shop_and_currency/curency_display.gd'

# We'll need a way to instantiate the script for testing.
var display: Label

func before_test() -> void:
	# Load the script file to get the type and instantiate it
	var script_path = 'res://scenes/shop_and_currency/curency_display.gd'
	var script = load(script_path)
	
	# Instantiate the script (it extends Label, but for testing, 
	# we treat it as the CurrencyDisplay class)
	display = script.new()
	# Call _ready() manually since it doesn't run automatically in unit tests
	display._ready()
	display.queue_free()

func test_add_balance() -> void:
	# Initial balance should be 0
	assert_int(display.get_balance()).is_equal(0)
	assert_str(display.text).is_equal("Balance: 0")

	# Test adding a positive amount
	assert_bool(display.add_balance(50)).is_true()
	assert_int(display.get_balance()).is_equal(50)
	assert_str(display.text).is_equal("Balance: 50")
	
	# Test adding another positive amount
	assert_bool(display.add_balance(10)).is_true()
	assert_int(display.get_balance()).is_equal(60)
	assert_str(display.text).is_equal("Balance: 60")
	
	# Test adding zero (should fail and not change balance)
	assert_bool(display.add_balance(0)).is_false()
	assert_int(display.get_balance()).is_equal(60) # Balance should still be 60
	
	# Test adding negative amount (should fail and not change balance)
	assert_bool(display.add_balance(-10)).is_false()
	assert_int(display.get_balance()).is_equal(60) # Balance should still be 60

	
func test_remove_balance() -> void:
	# Set initial balance for removal tests
	display.balance = 100
	display.display_balance()
	assert_int(display.get_balance()).is_equal(100)
	
	# Test removing a valid amount
	assert_bool(display.remove_balance(40)).is_true()
	assert_int(display.get_balance()).is_equal(60)
	assert_str(display.text).is_equal("Balance: 60")
	
	# Test removing an amount equal to the current balance
	assert_bool(display.remove_balance(60)).is_true()
	assert_int(display.get_balance()).is_equal(0)
	assert_str(display.text).is_equal("Balance: 0")
	
	# Set balance back up for over-removal test
	display.balance = 50
	display.display_balance()
	
	# Test removing more than the balance (should fail and not change balance)
	assert_bool(display.remove_balance(51)).is_false()
	assert_int(display.get_balance()).is_equal(50) # Balance should still be 50
	
	# Test removing zero (should fail and not change balance)
	assert_bool(display.remove_balance(0)).is_false()
	assert_int(display.get_balance()).is_equal(50)
	
	# Test removing negative amount (should fail and not change balance)
	assert_bool(display.remove_balance(-10)).is_false()
	assert_int(display.get_balance()).is_equal(50)


func test_get_balance() -> void:
	# Initial balance
	assert_int(display.get_balance()).is_equal(0)
	
	# After adding
	display.add_balance(75)
	assert_int(display.get_balance()).is_equal(75)
	
	# After removing
	display.remove_balance(25)
	assert_int(display.get_balance()).is_equal(50)
	
	# After being set directly (for completeness, though generally discouraged)
	display.balance = 120
	assert_int(display.get_balance()).is_equal(120)
	
func test_display_balance() -> void:
	# Initial display on _ready
	assert_str(display.text).is_equal("Balance: 0")
	
	# After direct balance change and manual call
	display.balance = 999
	display.display_balance()
	assert_str(display.text).is_equal("Balance: 999")
	
	# After add_balance (which calls display_balance internally)
	display.add_balance(1)
	assert_str(display.text).is_equal("Balance: 1000")
	
	# After remove_balance (which calls display_balance internally)
	display.remove_balance(500)
	assert_str(display.text).is_equal("Balance: 500")
