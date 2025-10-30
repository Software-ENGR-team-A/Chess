extends Label

@export var balance = 0

func _ready():
	display_balance()

func add_balance(amount : int) -> bool:
	if (amount <= 0):
		return false
	balance += amount
	display_balance() 
	return true

func remove_balance(amount: int) -> bool:
	if (amount <= 0):
		return false
		
	if amount > balance:
		return false
		
	balance -= amount 
	display_balance() 
	return true
	
func get_balance() -> int:
	return balance
	
func display_balance():
	self.text = "Balance: " + str(balance)
