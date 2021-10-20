
const LOOP_TICK_DURATION = 30.0

var board

var loop_count = 0

func start(_board):
    self.board = _board
    self.call_deferred("_loop_tick")

func _loop_tick():
    print("loop " + str(self.loop_count))

    self.loop_count += 1
    yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
    self.call_deferred("_loop_tick")
