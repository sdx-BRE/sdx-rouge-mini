shader_type spatial;
render_mode depth_prepass_alpha, specular_schlick_ggx; //, unshaded;

uniform float FadeAmount : hint_range(0.0, 1.0) = 1.0;

group_uniforms colors_and_fresnel;
uniform vec4 Color : source_color = vec4(1.0);
uniform float FresnelPower = 2.5;
uniform vec4 FresnelColor : source_color = vec4(1.0);
group_uniforms;

group_uniforms textures_and_uvs;
uniform sampler2D Ice_Texture : source_color;
uniform vec2 Tiling = vec2(1.0, 1.0);
uniform vec2 Offset = vec2(0.0, 0.0);
group_uniforms;

group_uniforms masks_and_screen_effects;
uniform sampler2D FrostMask : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float RefractionAmount = 1.0;
group_uniforms;

group_uniforms pbr;
uniform float normal_depth = 1.0;
uniform float Metallic : hint_range(0.0, 1.0) = 0.134;
uniform float Smoothness : hint_range(0.0, 1.0) = 0.627;
group_uniforms;

void fragment() {
	vec2 ice_uv = fract(UV * Tiling + Offset); 
	vec4 ice_tex = texture(Ice_Texture, ice_uv);
	float mask = texture(FrostMask, UV).r;

	float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), FresnelPower);
	vec3 fresnel_rgb = fresnel * FresnelColor.rgb;

	float uv_avg = (SCREEN_UV.x + SCREEN_UV.y) * 0.333333;
	float ref_offset_val = uv_avg + (uv_avg * ice_tex.r);
	vec2 ref_uv_diff = SCREEN_UV - vec2(ref_offset_val);
	vec2 final_screen_uv = SCREEN_UV + (ref_uv_diff * RefractionAmount);
	
	vec4 screen_tex = texture(SCREEN_TEXTURE, final_screen_uv);

	vec3 base_color = Color.rgb * (ice_tex.rgb + screen_tex.rgb);
	ALBEDO = fresnel_rgb + base_color;

	ALPHA = Color.a * mask * FadeAmount;
	
	
	
	METALLIC = Metallic;
	SPECULAR = Smoothness;
	
	NORMAL_MAP = ice_tex.rgb;
	NORMAL_MAP_DEPTH = normal_depth;
}