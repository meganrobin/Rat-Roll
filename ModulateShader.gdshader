shader_type canvas_item;

uniform vec4 old_color1: hint_color;
uniform vec4 old_color2: hint_color;
uniform vec4 old_color3: hint_color;
uniform vec4 modulate: hint_color;

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV);
	
    if ((distance(curr_color, old_color1) < 0.01) || (distance(curr_color, old_color2) < 0.01) || (distance(curr_color, old_color3) < 0.01)) {
        curr_color *= modulate;
	}

	COLOR = curr_color;
}