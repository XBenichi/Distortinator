shader_type canvas_item;
//replace "blend_mix" with "blend_add" or "blend_sub" or "blend_mul" to change blend mode
render_mode blend_mix;

//these are variables
uniform bool horizontal_distortion;
uniform bvec2 vertical_distortion;
uniform vec2 amplitude = vec2(0,0);
uniform vec2 frequency = vec2(0,0);
uniform float scale = 0.0;
uniform vec2 move = vec2(0,0);
uniform bool ping_pong;
uniform float palette_shifting_speed = 0;
uniform sampler2D palette;
uniform bool palette_shifting;
uniform bvec2 interleaved;
uniform float screen_height = 180;
uniform float screen_width = 320;

 void fragment(){
    vec2 newuv = UV;
	//tbh i dont know how to explain what it does, ill just say it makes the background move
	if (horizontal_distortion) { //oscillation
		newuv.x += amplitude.x * sin((frequency.x * newuv.y) + scale * TIME)/1.0;
	} else { //compression
		newuv.x += amplitude.x * sin((frequency.x * newuv.x) + scale * TIME)/1.0;
	}
	
	if (vertical_distortion.x) { //oscillation
		newuv.y += amplitude.y * cos((frequency.y * newuv.x) + scale * TIME)/1.0;
	} else if (vertical_distortion.y) { //compression
		newuv.y += amplitude.y * cos((frequency.y * newuv.y) + scale * TIME)/1.0;
	}
	//this one i can explain, it moves the texture to up and right using postives, down and left using negetives
	//the higher the number the faster it is
	if (ping_pong) {
		newuv.x += move.x * sin(scale * TIME);
		newuv.y += move.y * cos(scale * TIME);
	} else {
		newuv.x += TIME * move.x/0.5;
		newuv.y += TIME * move.y/0.5;
	}
	
	
	vec4 c = texture(TEXTURE, newuv);
	COLOR = c;
	float ccycle = mod(c.r - TIME * palette_shifting_speed, 1.0);
	float diff_x = 0.0;
	float diff_y = 0.0;
	
	
	if (palette_shifting) {
		COLOR = vec4(texture(palette, vec2(ccycle, 0)).rgb, c.a);
	}
	
	
	
	if (interleaved.x) {
		if ( int(UV.y * screen_height) % 2 == 0 ){
		
			diff_x += 0.075 * sin((amplitude.x * UV.y) + (2.0 * TIME));
		
		}else{
			diff_x += -0.075 * sin((amplitude.x * UV.y) + (2.0 * TIME));
		}
		
		if (palette_shifting) {
			palette_shifting_speed * 2.0;
			COLOR = COLOR + (texture(TEXTURE, vec2(newuv.x + diff_x, newuv.y)));
		} else{
			COLOR = (texture(TEXTURE, vec2(newuv.x + diff_x, newuv.y)));
		
	} else {
		
	}
	
	if (interleaved.y) {
		if ( int(UV.x * screen_width) % 2 == 0 ){
		
			diff_y += 0.075 * sin((amplitude.y * UV.x) + (2.0 * TIME));
		
		}else{
			diff_y += -0.075 * sin((amplitude.y * UV.x) + (2.0 * TIME));
		}
		COLOR = (texture(TEXTURE, vec2(newuv.x, newuv.y + diff_y)));
	}
	
}


