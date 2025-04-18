extends Node3D

const TARGET_SCALE := Vector3(103.437317, 100.000000, 123.951431)

func _ready():
	print("🔍 Searching for node with scale:", TARGET_SCALE)
	var found := false

	for node in get_tree().get_nodes_in_group("root"):
		check_node_recursively(node)

	if not found:
		print("✅ No node found with exact matching scale.")

func check_node_recursively(node: Node):
	if "scale" in node and node.scale == TARGET_SCALE:
		print("⚠️ Found matching node:")
		print("   🧱 Name :", node.name)
		print("   📂 Path :", node.get_path())
		print("   📐 Scale:", node.scale)
