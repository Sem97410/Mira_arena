// Stylized Slime Shader for Godot 4.x
// Features: Transparency, Glow, Wobble, Fresnel

shader_type spatial;
render_mode blend_mix,  cull_back, unshaded;

// Uniforms
uniform vec3 base_couleur :source_color;
uniform vec3 highlitght_color : source_color;
uniform float  intensity_move;// definis l'intensité du mouvement un peu comme un radius
uniform float speed; // definis le speed du mouvment  
uniform float noise_scale; // vas servir comme donné pour crée les déplacemnt des point
uniform float fresnel_power : hint_range(1.0, 10.00) =3.0;
uniform float fresnel_strength : hint_range(0.0, 2.0)=1.0;
uniform float emissive : hint_range(0.0, 1.0, 0.1);
uniform vec3 emission_color : source_color;
uniform sampler2D normal_texture : hint_normal;
uniform sampler2D noise_texture;
uniform float wobble_strength : hint_range(0.0, 0.5) = 0.1;
uniform float wobble_speed = 2.0;
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

    vec3 highlight = highlitght_color * fresnel * fresnel_strength;
    ALBEDO = base_couleur + highlight;
    ALPHA = 0.2;
    EMISSION = emission_color * fresnel * emissive;
}



