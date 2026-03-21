shader_type spatial;

uniform sampler2D albedo_a : source_color, hint_default_white;
uniform sampler2D albedo_b : source_color, hint_default_white;

uniform sampler2D normal_a : hint_normal;
uniform sampler2D normal_b : hint_normal;

uniform sampler2D roughness_a : hint_default_white;
uniform sampler2D roughness_b : hint_default_white;

uniform sampler2D metallic_a : hint_default_black;
uniform sampler2D metallic_b : hint_default_black;

uniform sampler2D ambient_occlusion_a : hint_default_white;
uniform sampler2D ambient_occlusion_b : hint_default_white;

uniform sampler2D noise_tex : hint_default_white;

uniform float scale_a = 15.0;
uniform float scale_b = 12.0;

vec3 blend_v3(sampler2D tex_a, sampler2D tex_b, vec2 uv_a, vec2 uv_b, float weight) {
	return mix(
		texture(tex_a, uv_a).rgb,
		texture(tex_b, uv_b).rgb,
		weight
	);
}

float blend_f1(sampler2D tex_a, sampler2D tex_b, vec2 uv_a, vec2 uv_b, float weight) {
	return mix(
		texture(tex_a, uv_a).r,
		texture(tex_b, uv_b).r,
		weight
	);
}

void fragment() {
	vec2 uv_a = UV * scale_a;
    vec2 uv_b = UV * scale_b;
    float weight = texture(noise_tex, UV).r;
	
	ALBEDO = blend_v3(albedo_a, albedo_b, uv_a, uv_b, weight);
	NORMAL_MAP = blend_v3(normal_a, normal_b, uv_a, uv_b, weight);
	NORMAL_MAP_DEPTH = 1.0;
	
	AO = blend_f1(ambient_occlusion_a, ambient_occlusion_b, uv_a, uv_b, weight);
	ROUGHNESS = blend_f1(roughness_a, roughness_b, uv_a, uv_b, weight);
	METALLIC = blend_f1(metallic_a, metallic_b, uv_a, uv_b, weight);
}
