shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx, unshaded, shadows_disabled, ambient_light_disabled;

uniform vec4 Color : source_color = vec4(0.160200, 0.439957, 0.890000, 0.239216);
uniform float FresnelPower = 1.25;

void fragment() {
	float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), FresnelPower);
	float n_out5p0 = Color.a * fresnel;
	
	ALBEDO = vec3(Color.rgb);
	ALPHA = n_out5p0;
}
