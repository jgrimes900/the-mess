shader_type spatial;

render_mode cull_back, unshaded, diffuse_burley;

uniform sampler2D Texture: source_color;
uniform sampler2D Texture_Alpha: filter_nearest;
uniform float random;

void fragment() {
	vec2 uvmod = UV;
	uvmod.g *= 5.0;
	vec4 tex_color = texture(Texture, uvmod);
	ALBEDO = tex_color.rgb;
	vec4 tex_alpha = texture(Texture_Alpha, uvmod);
	ALPHA = float(int(tex_alpha.a*random)%int(uvmod.g+2.0) <= int(uvmod.g));
}