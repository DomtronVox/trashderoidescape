extends Node

var resources = {
	"fasteners": 0,
	"copper": 0,
	"steel": 0
}

var clearing_speed = 20

var current_upgrade = 0


func award_resource():
	self.resources[self.resources.keys()[randi_range(0, self.resources.size()-1)]] += 1

func deduct_resources():
	for resource in self.resources.keys():
		self.resources[resource] -= Global.upgrades[self.current_upgrade][resource]
	
func valid_resources() -> bool:
	#return true # FIXME DEBUG
	
	#we have passed the last upgrade so everything is valid. 
	if Global.upgrades.size()-1 < self.current_upgrade:
		return true
	
	for resource in self.resources.keys():
		if self.resources[resource] < Global.upgrades[self.current_upgrade][resource]:
			return false
	return true
