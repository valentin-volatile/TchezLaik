shader_type canvas_item;

uniform float factor = 0.15;

void vertex(){
	UV.x += TIME*factor;
	UV.y += TIME*factor;
}
