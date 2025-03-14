
shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float brush_stroke_size = 0.005; // Taille des coups de pinceau
uniform float distortion_intensity = 0.02; // Force de la déformation
uniform float blur_strength = 0.8; // Intensité du mélange entre original et flouté

void fragment() {
    // Récupérer la couleur de l'écran
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;

    // Générer une légère distorsion aléatoire basée sur SCREEN_UV
    vec2 random_offset = vec2(
        fract(sin(dot(SCREEN_UV, vec2(12.9898, 78.233))) * 43758.5453),
        fract(sin(dot(SCREEN_UV, vec2(39.3461, 11.135))) * 43758.5453)
    ) - 0.5; // Centré autour de 0

    vec2 distorted_uv = SCREEN_UV + random_offset * distortion_intensity;

    // Effet de peinture avec moyenne des couleurs voisines (flou directionnel)
    vec3 blurred_color = (
        texture(screen_texture, distorted_uv + vec2(brush_stroke_size, 0.0)).rgb +
        texture(screen_texture, distorted_uv + vec2(-brush_stroke_size, 0.0)).rgb +
        texture(screen_texture, distorted_uv + vec2(0.0, brush_stroke_size)).rgb +
        texture(screen_texture, distorted_uv + vec2(0.0, -brush_stroke_size)).rgb
    ) * 0.25;

    // Mélange pour adoucir l’effet
    vec3 paint_effect = mix(screen_color, blurred_color, blur_strength);

    // Appliquer le résultat
    ALBEDO = paint_effect;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
