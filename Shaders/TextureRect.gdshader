/**
 * This shader creates fisheye or barrel distortion by sliding values in the
 * desired direction. It aims to have a minimal amount of pixelation, and was
 * originally conceived of to procedurally generate cartoon planets and bodies
 * from easily generatable flat textures.
 *
 * Thanks to user Dan (6145) on Stack Overflow for providing the math. I also
 * stole some code from here for the texture placement:
 * https://gist.github.com/quiglemj/971f4cec1b128c58b4864c5200bfc579
 * This shader differs from the above gist in that it does not stretch the
 * center towards the edges, but rather crushes the edges in towards the
 * center, and thus eliminates pixelation entirely while achieving a near
 * identical effect.
 *
 * See the final result in the edited part of my SO question:
 * https://computergraphics.stackexchange.com/questions/9434/shader-or-formula-that-distorts-inward
 *
 * License: CC0
 * https://creativecommons.org/publicdomain/zero/1.0/
 */

shader_type canvas_item;

// Inspector params:
uniform float effect = -1.1; // -1.0 is BARREL, 0.1 is PINCUSHION. For planets, ideally -1.1 to -4.
uniform float effect_scale = 1.1; // Play with this to slightly vary the results.
uniform bool dynamic_crop = false; // Guesses the crop amount with an admittedly badly inaccurate formula.
uniform bool manual_crop = false; // Cut out the junk outside the sphere.
uniform float manual_amount = 0.95; // Higher value = more crop.

vec2 distort(vec2 p) {
	float d = length(p);
	float z = sqrt(1.0 + d * d * effect);
	float r = atan(d, z) / 3.14159;
	r *= effect_scale;
	float phi = atan(p.y, p.x);
	return vec2(r*cos(phi)+.5,r*sin(phi)+.5);
}

void fragment(){
	vec2 newuv = UV;
	newuv.x += TIME * 0.5;
	vec2 xy = (2.0 * UV);
	xy.x = xy.x - 1.0;
	xy.y = xy.y - 1.0;

	// Dynamic crop adjustment. -0.5 is equavalent to 'none'.
	float d_adjust = -0.5;
	if (dynamic_crop) {
		d_adjust = (effect/4.0) * -0.6;
	}

	// Perform distortion if needed.
	vec4 tex;
	float d = length(xy);
	if (d < 1.0 - d_adjust) {
		xy = distort(xy);
		tex = texture(TEXTURE, xy + newuv);
		COLOR = tex;
		
	}
	else {
		COLOR.a = 0.0;
	}

	// Apply manual crop.
	if (manual_crop && d > manual_amount) {
		COLOR.a = 0.0;
	}
}