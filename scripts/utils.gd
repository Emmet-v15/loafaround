extends Node


static func approximately_equal(
	a: float, 
	b: float, 
	epsilon: float = 0.001, 
	wrap_min: float = NAN, 
	wrap_max: float = NAN
) -> bool:
	if is_nan(wrap_min) || is_nan(wrap_max):
		# Standard float comparison
		return abs(a - b) < epsilon
	else:
		# Handle wrapped values (like angles)
		var wrapped_diff = wrapf(a - b, wrap_min, wrap_max)
		return abs(wrapped_diff) < epsilon
