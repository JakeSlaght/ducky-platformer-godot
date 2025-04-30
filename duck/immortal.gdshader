shader_type canvas_item;

uniform float time_passed : hint_range(0.0, 1.0);  // How much time has passed (from 0 to 1)

void fragment() {
	vec4 texture_default = texture(TEXTURE, UV);
	// Loop the time_passed using modulo to keep it between [0, 1]
	float offset = mod(time_passed, 1.0);
	float default_alpha = texture_default.a;
	
	vec4 rainbow_color = vec4(1.0, 0.3, 0.3, 1.0); // Default red
	
	// Mapping the offset to a color palette (rainbow colors)
	if (offset < 0.125) {
	    rainbow_color = vec4(1.0,  0.3, 0.3, default_alpha); // Red
	} else if (offset < 0.25) {
	    rainbow_color = vec4(1.0, 0.65, 0.0, default_alpha); // Orange
	} else if (offset < 0.375) {
	    rainbow_color = vec4(1.0,  1.0, 0.0, default_alpha); // Yellow
	} else if (offset < 0.5) {
	    rainbow_color = vec4(0.0, 1.0, 0.0, default_alpha); // Green
	} else if (offset < 0.625) {
	    rainbow_color = vec4(0.0, 0.56, 1.0, default_alpha); // Cyan
	} else if (offset < 0.75) {
	    rainbow_color = vec4(0.29, 0.0, 0.5, default_alpha); // Indigo
	} else if (offset < 0.875) {
	    rainbow_color = vec4(0.55, 0.0, 1.0, default_alpha); // Violet
	} else {
	    rainbow_color = vec4(1.0, 0.0, 1.0, default_alpha); // Magenta
	}
	// Blend the rainbow color on top of the base texture
    COLOR = mix(texture_default, rainbow_color, 0.5); // 0.5 = 50% blend
}
