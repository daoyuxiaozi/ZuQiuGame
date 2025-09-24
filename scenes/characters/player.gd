class_name Player  # 类名：玩家（其他脚本可以直接用 Player 引用这个类）
extends CharacterBody2D  # 继承 Godot 的 2D 角色身体（提供 velocity、碰撞与移动辅助方法）

# 控制方案枚举：cpu（电脑控制）/ p1（玩家1）/ p2（玩家2）
# 在 Inspector 中会显示为下拉选择，便于在编辑器里指定此实例的控制者
enum ControlScheme { cpu, p1, p2 }

@export var control_scheme : ControlScheme  # 在 Inspector 里选择谁控制（可在运行前或运行时修改）
@export var speed : float = 90  # 移动速度（单位通常是像素/秒 — 具体感受取决于项目中 delta 的使用方式和像素密度）

# 运行时绑定场景里的 AnimationPlayer 节点（确保场景中存在名为 AnimationPlayer 的节点）
# @onready 会在节点进入场景树后执行绑定，使变量可以直接引用节点
@onready var animation_player : AnimationPlayer = %AnimationPlayer
# 同理绑定控制角色显示的 Sprite2D（确保场景里有名为 PlayerSprite 的 Sprite2D）
@onready var player_sprite: Sprite2D = %PlayerSprite

# 当前面朝方向（用于决定贴图翻转等）——默认为向右
var heading := Vector2.RIGHT

# 注意：CharacterBody2D 提供了 velocity 属性（此脚本直接修改 velocity 以驱动移动）
# _physics_process 在每个物理帧调用（固定步长），适合做移动/碰撞逻辑
func _physics_process(_delta: float) -> void:
	# 1) 根据控制方案决定移动控制逻辑
	if control_scheme == ControlScheme.cpu:
		# 电脑控制分支：此处暂不处理（可扩展：AI 路径、巡逻、追踪玩家等）
		pass
	else:
		# 人类玩家控制：读取输入并设置 velocity
		handle_human_movement()
		
	# 2) 根据当前 velocity 切换动画（跑动或待机）
	set_movement_animation()
	# 3) 根据水平速度调整朝向（heading）
	set_heading()
	# 4) 翻转精灵以匹配 heading（水平翻转）
	flip_sprites()
	# 5) 把 velocity 应用到物理引擎，使角色实际移动并处理碰撞
	# move_and_slide() 是 CharacterBody2D 的便捷方法，会基于 velocity 进行滑动与碰撞响应
	move_and_slide()

# 处理玩家输入并设置 velocity
func handle_human_movement() -> void:
	# KeyUtils.get_input_vector(control_scheme) 假定返回一个 Vector2（x,y）表示输入方向
	# - 典型实现：返回归一化方向向量（例如按右键 -> Vector2(1,0)，按上键 -> Vector2(0,-1)）
	# - 注意：如果 KeyUtils 返回的向量不是单位向量，可能需要 normalize()，但这里假设其已处理
	var direction := KeyUtils.get_input_vector(control_scheme)
	# 把方向乘以速度得到速度向量（每秒像素数），并直接赋值给 CharacterBody2D 的 velocity
	# 若需要考虑 delta（帧率独立）也可以在其他位置乘以 delta，但 CharacterBody2D 的 move_and_slide
	# 通常期望 velocity 表示“每秒”的速度，所以直接这样写是常见做法
	velocity = direction * speed

# 根据 velocity 切换当前播放的动画（运行或待机）
func set_movement_animation() -> void:
	# velocity.length() > 0 说明在移动；这里用了严格 >0 判断，若有浮点精度担心可用小阈值判断
	if velocity.length() > 0:
		# 播放名为 "run" 的动画（确保 AnimationPlayer 定义了此动画）
		animation_player.play("run")
	else:
		# 否则播放 "idle"（待机）动画
		animation_player.play("idle")

# 根据水平速度来更新 heading（朝向向量）
# 仅水平分量决定朝向，垂直移动不会改变朝向
func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT
	# 如果 velocity.x == 0，则保持原有 heading（不改变面朝方向）

# 根据 heading 翻转角色精灵（常用于 2D 横向游戏）
func flip_sprites() -> void:
	# Sprite2D.flip_h 为水平翻转开关（true 表示左右镜像）
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true
