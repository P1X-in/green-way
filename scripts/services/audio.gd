extends Node

const BUS_SFX = "SFX"
const BUS_MUSIC = "Music"

var samples = {}
var soundtracks = {}
var current_track = null

var sounds_enabled = true
var music_enabled = true

func _ready():
	self.register_sample("menu_click", preload("res://assets/audio/menu.wav"))
	self.register_sample("click", preload("res://assets/audio/hammer_27.wav"))
	self.register_sample("destroy_road", preload("res://assets/audio/clap_13.wav"))
	self.register_sample("build_1", preload("res://assets/audio/hammer_hits_23.wav"))
	self.register_sample("build_2", preload("res://assets/audio/hammer_hits_26.wav"))
	self.register_sample("build_0", preload("res://assets/audio/hammer_hits_25.wav"))
	self.register_sample("build_road", preload("res://assets/audio/hit_16.wav"))
	self.register_sample("haha", preload("res://assets/audio/haha_33.wav"))
	self.register_sample("close", preload("res://assets/audio/jeb_32.wav"))
	self.register_sample("dog_0", preload("res://assets/audio/woof_34.wav"))
	self.register_sample("dog_1", preload("res://assets/audio/woof_35.wav"))
	self.register_sample("dog_2", preload("res://assets/audio/woof_36.wav"))
	self.register_sample("dog_3", preload("res://assets/audio/woof_37.wav"))
	self.register_sample("dog_4", preload("res://assets/audio/woof_38.wav"))
	self.register_sample("dog_5", preload("res://assets/audio/woof_39.wav"))
	self.register_sample("dog_6", preload("res://assets/audio/woof_40.wav"))
	self.register_sample("dog_7", preload("res://assets/audio/woof_41.wav"))
	self.register_sample("garbage_0", preload("res://assets/audio/glass_02.wav"))
	self.register_sample("garbage_1", preload("res://assets/audio/glass_03.wav"))
	self.register_sample("garbage_2", preload("res://assets/audio/glass_10.wav"))
	self.register_sample("garbage_3", preload("res://assets/audio/metal_17.wav"))
	self.register_sample("garbage_4", preload("res://assets/audio/metal_18.wav"))
	self.register_sample("garbage_5", preload("res://assets/audio/metal_19.wav"))
	self.register_sample("garbage_6", preload("res://assets/audio/metal_box_12.wav"))
	self.register_sample("garbage_7", preload("res://assets/audio/garbage_05.wav"))
	self.register_sample("garbage_8", preload("res://assets/audio/garbage_11.wav"))
	self.register_sample("garbage_9", preload("res://assets/audio/steam_07.wav"))

	self.register_track("menu", preload("res://assets/audio/soundtrack/soundtrack.ogg"))

func param_play(name, pitch = 1, vol = 0):
	if not self.sounds_enabled:
		return

	if not self.samples.has(name):
		return
	self.samples[name].set_pitch_scale(pitch)
	self.samples[name].set_volume_db(vol)

	self.samples[name].play()
	self.samples[name].set_pitch_scale(1)
	self.samples[name].set_volume_db(0)

func play(name):
	if not self.sounds_enabled:
		return

	if not self.samples.has(name):
		return
	self.samples[name].play()

func track(name):
	if not self.music_enabled:
		return

	if not self.soundtracks.has(name):
		return

	self.stop()
	self.soundtracks[name].play()
	self.current_track = self.soundtracks[name]

func stop(name=null):
	if name == null and self.current_track != null:
		self.current_track.stop()
		self.current_track = null
	elif self.soundtracks.has(name):
		self.soundtracks[name].stop()

func pause(name=null):
	if name == null and self.current_track != null:
		self.current_track.set_stream_paused(true)
	elif self.soundtracks.has(name):
		self.soundtracks[name].set_stream_paused(true)

func unpause(name=null):
	if name == null and self.current_track != null:
		self.current_track.set_stream_paused(false)
	elif self.soundtracks.has(name):
		self.soundtracks[name].set_stream_paused(false)


func register_sample(name, stream):
	if stream == null:
		return

	var sfx = AudioStreamPlayer.new()
	self.get_tree().get_root().call_deferred("add_child", sfx)
	sfx.set_stream(stream)
	sfx.set_bus(self.BUS_SFX)

	self.samples[name] = sfx


func register_track(name, stream):
	if stream == null:
		return

	var track = AudioStreamPlayer.new()
	self.get_tree().get_root().call_deferred("add_child", track)
	track.set_stream(stream)
	track.set_bus(self.BUS_MUSIC)

	self.soundtracks[name] = track
