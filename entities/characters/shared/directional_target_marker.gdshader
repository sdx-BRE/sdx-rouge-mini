shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_opaque, cull_disabled;

uniform vec4 base_color : source_color = vec4(0.3, 0.3, 0.3, 0.6);
uniform vec4 charge_color : source_color = vec4(1.0, 0.4, 0.0, 1.0);
uniform float charge_amount : hint_range(0.0, 1.0) = 0.0;

uniform float stem_width : hint_range(0.0, 1.0) = 0.1;
uniform float head_width : hint_range(0.0, 1.0) = 0.275;
uniform float head_size : hint_range(0.0, 1.0) = 0.333;

uniform bool use_pulse = true;
uniform float pulse_speed = 4.0;
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.2;

void vertex() {
    POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    POSITION.z -= 0.001; 
}

void fragment() {
    float x = (UV.x - 0.5) * 2.0;
    float y = (UV.y - 0.5) * 2.0; 
    float abs_x = abs(x);
    
    float head_start_y = 1.0 - head_size;
    float current_head_width = (1.0 - y) * (head_width / head_size); 
    
    float aa = fwidth(abs_x);
    float head_shape = smoothstep(current_head_width + aa, current_head_width - aa, abs_x);
    head_shape *= step(head_start_y, y);
    
    float stem_shape = smoothstep(stem_width + aa, stem_width - aa, abs_x);
    stem_shape *= step(y, head_start_y);
    
    float arrow_mask = clamp(head_shape + stem_shape, 0.0, 1.0) * step(0.0, y);

    float pulse = 1.0;
    if (use_pulse) {
        pulse = 1.0 + (sin(TIME * pulse_speed) * pulse_intensity);
    }

    bool is_charged = y <= charge_amount;
    vec3 final_rgb = is_charged ? charge_color.rgb * pulse : base_color.rgb;
    float final_alpha = is_charged ? charge_color.a : base_color.a;

    ALBEDO = final_rgb;
    ALPHA = arrow_mask * final_alpha;
}