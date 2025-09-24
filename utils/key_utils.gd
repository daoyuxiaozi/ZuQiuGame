extends Node  # 挂在场景上的节点（就是这个脚本挂在哪个物件上）

enum Action {LEFT,RIGHT,UP,DOWN,SHOOT,PASS}  # 定义动作名字：左、右、上、下、射门、传球

const ACTIONS_MAP : Dictionary = {  # 动作到输入名的对照表（下面是具体内容）
	Player.ControlScheme.p1:{  # 玩家1的按键配置开始
		Action.LEFT:"p1_left",   # 玩家1 向左 的输入名叫 p1_left
		Action.RIGHT:"p1_right", # 玩家1 向右 的输入名叫 p1_right
		Action.UP:"p1_up",       # 玩家1 向上 的输入名叫 p1_up
		Action.DOWN:"p1_down",   # 玩家1 向下 的输入名叫 p1_down
		Action.SHOOT:"p1_shoot", # 玩家1 射门 的输入名叫 p1_shoot
		Action.PASS:"p1_pass",   # 玩家1 传球 的输入名叫 p1_pass
	},  # 玩家1的按键配置结束
	Player.ControlScheme.p2:{  # 玩家2的按键配置开始
		Action.LEFT:"p2_left",   # 玩家2 向左 的输入名叫 p2_left
		Action.RIGHT:"p2_right", # 玩家2 向右 的输入名叫 p2_right
		Action.UP:"p2_up",       # 玩家2 向上 的输入名叫 p2_up
		Action.DOWN:"p2_down",   # 玩家2 向下 的输入名叫 p2_down
		Action.SHOOT:"p2_shoot", # 玩家2 射门 的输入名叫 p2_shoot
		Action.PASS:"p2_pass",   # 玩家2 传球 的输入名叫 p2_pass
	},  # 玩家2的按键配置结束
}  # 动作到输入名的对照表结束

# get_input_vector表示获取玩家方向
func get_input_vector(scheme:Player.ControlScheme) -> Vector2:  # 根据给定的玩家方案，返回方向向量（左右上下）
	var map : Dictionary = ACTIONS_MAP[scheme]  # 取出对应玩家的按键表（比如 p1 或 p2）
	return Input.get_vector(map[Action.LEFT],map[Action.RIGHT],map[Action.UP],map[Action.DOWN])  # 把 左 右 上 下 这四个输入名转换为 Vector2 并返回（就是方向：左=-1,0 右=1,0 上=0,-1 下=0,1）

# is_action_pressed表示动作是否被按下,如键盘,鼠标等
func is_action_pressed(scheme:Player.ControlScheme, action: Action) -> bool:  # 返回 指定玩家（scheme） 的指定动作（action） 当前是否被按住（布尔）
	return Input.is_action_pressed(ACTIONS_MAP[scheme][action])  # 通过 ACTIONS_MAP 把动作转换成 Input Map 名称，再询问 Godot 的 Input 是否被按住

# 单次触发行为（比如一次射击、跳跃、切换界面）用 just_pressed，避免持续触发好几次。
func is_action_just_pressed(scheme:Player.ControlScheme, action: Action) -> bool:  
	return Input.is_action_just_pressed(ACTIONS_MAP[scheme][action])  

# 
func is_action_just_released(scheme:Player.ControlScheme, action: Action) -> bool:  
	return Input.is_action_just_released(ACTIONS_MAP[scheme][action])
