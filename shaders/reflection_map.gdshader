shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D PanoramicTexture;

uniform float z_clip_scale : hint_range(0.0, 1.0) = 1.0;

void vertex() {
    vec4 clip_pos = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    clip_pos.z = mix(clip_pos.w, clip_pos.z, z_clip_scale);
   	POSITION = clip_pos;
}

void fragment() {
	vec3 view_dir = VIEW;
	vec3 normal = NORMAL;
	vec3 reflect_dir = reflect(-view_dir, normal);

	float longitude = atan(reflect_dir.x, reflect_dir.z); // [-PI, PI]
	float latitude = acos(clamp(reflect_dir.y, -1.0, 1.0)); // [0, PI]

	longitude = (longitude + 3.14159265359) / (2.0 * 3.14159265359); // [0..1]
	latitude = latitude / 3.14159265359; // [0..1]

	vec2 uv = vec2(longitude, latitude);

	vec4 tex_color = texture(PanoramicTexture, uv);
	ALBEDO = tex_color.rgb;
}
