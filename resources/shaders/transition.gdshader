shader_type canvas_item;

uniform float percent_visible = 0.0;

void fragment(){

	//COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, percent_visible - (UV.x * UV.y));
	if (UV.x+ UV.y <= percent_visible){
		COLOR.a = COLOR.a;
	}
	else{
		COLOR.a = 0.0;
	}
}