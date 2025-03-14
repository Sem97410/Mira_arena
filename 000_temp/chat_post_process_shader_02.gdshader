

shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture; // Capture de l’écran
uniform sampler2D noise_texture; // Bruit pour simuler la déformation
uniform float brush_stroke_size = 0.01; // Taille des coups de pinceau
uniform float distortion_intensity = 0.02; // Intensité de la déformation
uniform float blur_strength = 0.6; // Force du flou

void fragment() {
    // Récupérer la couleur de base de l’écran
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;

    // Ajouter une distorsion basée sur une texture de bruit
    vec2 noise_value = texture(noise_texture, SCREEN_UV * 5.0).rg; // Bruit aléatoire
    vec2 distortion = (noise_value - 0.5) * distortion_intensity; // Centrage du bruit autour de 0
    vec2 distorted_uv = SCREEN_UV + distortion; // Modifier les UVs

    // Appliquer un effet de flou en moyennant plusieurs échantillons proches
    vec3 blurred_color = (
        texture(screen_texture, distorted_uv + vec2(brush_stroke_size, 0.0)).rgb +
        texture(screen_texture, distorted_uv + vec2(-brush_stroke_size, 0.0)).rgb +
        texture(screen_texture, distorted_uv + vec2(0.0, brush_stroke_size)).rgb +
        texture(screen_texture, distorted_uv + vec2(0.0, -brush_stroke_size)).rgb
    ) * 0.25; // Moyenne des couleurs voisines

    // Mélanger la couleur de base avec la couleur floutée pour un effet peinture
    vec3 paint_effect = mix(screen_color, blurred_color, blur_strength);

    // Appliquer le rendu final
    //ALBEDO = paint_effect;
	ALBEDO = texture(noise_texture,SCREEN_UV).rgb;
}

 


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
