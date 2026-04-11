shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx, depth_prepass_alpha, shadows_disabled, ambient_light_disabled;

group_uniforms fragment_shader;
uniform vec4 Color : source_color;
uniform sampler2D NoiseFrg;
uniform sampler2D MaskFrg;
uniform vec2 Speed = vec2(0.0, 0.2);
uniform vec4 Emission : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float EmissionMultiplier = 1.5;
group_uniforms;

group_uniforms vertex_shader;
uniform bool enable_vertex;
uniform bool use_fragment_textures;
uniform sampler2D NoiseVtx;
uniform sampler2D MaskVtx;
uniform vec2 Speed2 = vec2(0.0, 0.2);
uniform float Displacement_Intensity = 0.2;
group_uniforms;

void fragment() {
    vec2 panned_uv = (TIME * Speed) + UV;
    
    float noise = texture(NoiseFrg, panned_uv).r;
    float mask = texture(MaskFrg, UV).r;
    
    float alpha_base = clamp(noise - mask, 0.0, 1.0);
    
    float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
    
    ALBEDO = Color.rgb;
    ALPHA = alpha_base * fresnel;
    EMISSION = Emission.rgb * EmissionMultiplier;
}

void vertex() {
    vec2 panned_uv = (TIME * Speed2) + UV;
    
	float noise_tex;
	float mask_tex;
	float noise;
	float mask;
	
	if (use_fragment_textures) {
		noise = texture(NoiseFrg, panned_uv).r;
		mask = texture(MaskFrg, UV).r;
	} else {
		noise = texture(NoiseVtx, panned_uv).r;
		mask = texture(MaskVtx, UV).r;
	}
	
    float displacement = (noise - mask) * Displacement_Intensity;
    
    VERTEX += NORMAL * displacement;
}
