extends KinematicBody2D

#variables
var speedX=0
var speedY=0
var velocity=Vector2(0,0)
var facingDirection=0
var moveDirection=0
var playerSprite
var jumpCount=0
var maxJump=1
var deltaTime=0
var landed
#constants
const maxSpeed=175
const moveMult=250
const jumpPower=-200
const gravity=300
const Floor=Vector2(0,-1)


func _animatePlayer():
	if(is_on_wall()):
		if playerSprite.get_frame()>=3:
			playerSprite.set_frame(0)
		if  playerSprite.get_frame()<3:
			playerSprite.set_frame(playerSprite.get_frame()+1)
		deltaTime=0
		pass
	
func _ready() -> void:
	set_process(true)
	playerSprite=get_node("Player")
	pass 
	
	
func _process(delta: float) -> void:
	if(Input.is_action_pressed("ui_up")and jumpCount<maxJump):
		speedY=jumpPower
		jumpCount+=1
		playerSprite.set_frame(5)
		landed=false
		
	if(Input.is_action_pressed("ui_right")):
		facingDirection=1
		playerSprite.set_flip_h(false)
		deltaTime=deltaTime+delta
		if deltaTime>0.1:
			if landed==true:
				_animatePlayer()
			
	elif(Input.is_action_pressed("ui_left")):
		facingDirection=-1
		playerSprite.set_flip_h(true)
		deltaTime=deltaTime+delta
		if deltaTime>0.1:
			if landed==true:
				_animatePlayer()
			
	else:
		facingDirection=0
		if(landed):
			playerSprite.set_frame(4)
		
	
	if(velocity.x==0 and landed):
		playerSprite.set_frame(0)
	
	if(facingDirection!=0):
		speedX+=delta*moveMult
		moveDirection=facingDirection
	else:speedX-=delta*1.5*moveMult
	
	speedX=clamp(speedX,0,maxSpeed)
	speedY+=gravity*delta
	velocity.x=speedX*1.5*moveDirection
	velocity.y=speedY*1.5
	if (is_on_floor()):
		
		jumpCount=0
		if (!landed):
			playerSprite.set_frame(5)
			landed=true
	#if(is_on_ceiling() or is_on_floor()):
	#	speedX=0
	move_and_slide(velocity,Floor)
		
	pass