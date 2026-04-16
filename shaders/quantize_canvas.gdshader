shader_type canvas_item;

uniform int amount = 1;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	color.r = float(int(color.r*255.0) << amount & 255)/255.0;
	color.g = float(int(color.g*255.0) << amount & 255)/255.0;
	color.b = float(int(color.b*255.0) << amount & 255)/255.0;
	COLOR = color;
}
