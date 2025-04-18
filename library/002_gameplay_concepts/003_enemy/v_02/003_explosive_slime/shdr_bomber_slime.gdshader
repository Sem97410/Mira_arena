// Stylized Slime Shader for Godot 4.x
// Features: Transparency, Glow, Wobble, Fresnel

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

// Uniforms
uniform vec4 slime_color : source_color = vec4(0.3, 1.0, 0.4, 0.5); // Base color with alpha
uniform sampler2D normal_texture : hint_normal;
uniform sampler2D noise_texture;
uniform float wobble_strength : hint_range(0.0, 0.5) = 0.1;
uniform float wobble_speed = 2.0;
uniform float fresnel_power = 4.0;
uniform float emission_strength : hint_range(0.0, 5.0) = 1.5;
uniform float min_fresnel : hint_range(0.0, 1.0) = 0.1;

// VERTEX FUNCTION: adds wobble based on world position + time
void vertex() {
    if (wobble_strength > 0.0 && wobble_speed > 0.0) {
        float t = TIME * wobble_speed;
        float offset = sin(VERTEX.x * 3.0 + t) * wobble_strength;
        VERTEX.y += offset;
        VERTEX.z += cos(VERTEX.x * 3.0 + t) * wobble_strength;
    }
}

// FRAGMENT FUNCTION: color + fresnel + glow
void fragment() {
    vec3 view_dir = normalize(-VIEW);
    float fresnel_raw = 1.0 - dot(NORMAL, view_dir);
    float fresnel = max(min_fresnel, pow(smoothstep(0.0, 1.0, fresnel_raw), fresnel_power));

    // Base Color with Fresnel
    vec3 base_color = slime_color.rgb + fresnel * 0.2;
    ALBEDO = base_color;
    ALPHA = slime_color.a;

    // Optional emission (glow)
    if (emission_strength > 0.0) {
        EMISSION = base_color * fresnel * emission_strength;
    } else {
        EMISSION = vec3(0.0);
    }

    // Simple fake refraction (optional):
    // vec2 screen_uv = SCREEN_UV + NORMAL.xy * 0.05;
    // ALBEDO = textureLod(SCREEN_TEXTURE, screen_uv, 0.0).rgb;
}



