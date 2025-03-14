shader_type spatial;
render_mode unshaded;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D noise_texture ;
uniform float effect_thresold = 0.5; 
uniform float paint_variation_intensity;
uniform float alpha_intensity : hint_range(0.0, 1.0, 0.1);
uniform float distorsion_strenght;


void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	 // Récupération de la profondeur et linéarisation
    float base_depth = texture(depth_texture, SCREEN_UV).r;
    float linear_depth = 1.0 / (base_depth * 10.0 + 1.0);

    // Récupère la couleur de l’écran
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;

    // 🔹 Étape 1 : Récupérer uniquement deux composantes du bruit
    vec2 noise_offset = texture(noise_texture, SCREEN_UV).rg;

    // 🔹 Étape 2 : Centrer la valeur autour de 0
    noise_offset -= vec2(0.5);

    // 🔹 Étape 3 : Appliquer la force de distorsion
    vec2 uv_offset = noise_offset * distorsion_strenght;

    // 🔹 Étape 4 : Réduire l'effet près des bords
    vec2 edge_factor = SCREEN_UV * (1.0 - SCREEN_UV);
    uv_offset *= edge_factor * 4.0;

    // 🔹 Étape 5 : Appliquer et limiter la distorsion des UVs
    vec2 distorded_uv = SCREEN_UV + uv_offset;
    distorded_uv = clamp(distorded_uv, vec2(0.0), vec2(1.0));

    // Récupère la couleur après distorsion
    vec3 distorded_color = texture(screen_texture, distorded_uv).rgb;

    // Applique un fondu progressif en fonction de la profondeur
	float object_intensity = smoothstep(0.2, effect_thresold, linear_depth);
    float effect_strength = object_intensity * smoothstep(0.0, effect_thresold, linear_depth);

    // Applique l'effet peinture avec la distorsion corrigée
    vec3 paint_effect = mix(screen_color, distorded_color, effect_strength);

    // Applique le résultat
    ALBEDO = paint_effect;
    ALPHA = alpha_intensity;
	

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
