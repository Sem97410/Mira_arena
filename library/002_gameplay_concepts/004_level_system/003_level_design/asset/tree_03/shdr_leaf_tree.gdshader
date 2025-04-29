shader_type spatial;
render_mode cull_disabled;

// Paramètres du Toon Shading

uniform float amplitude : hint_range(0.0, 1.0) = 0.1;
uniform float frequency : hint_range(0.0, 10.0) = 2.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;



uniform vec3 top_tint_color : source_color = vec3(0.8, 1.0, 0.8);   // Couleur au sommet
uniform vec3 bottom_tint_color : source_color = vec3(0.2, 0.5, 0.2); // Couleur à la base
uniform sampler2D albedo_texture ;
uniform vec4 shadow_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 light_color : source_color = vec4(1.0, 0.9, 0.8, 1.0);
uniform float shadow_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float shadow_smoothness : hint_range(0.0, 0.5) = 0.1;

// Paramètres des contours noirs
uniform float outline_thickness : hint_range(0.001, 0.02) = 0.005;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void vertex() {
    // crée une vague sinusoïdale basée sur la position en X et Z
    float wave = sin((VERTEX.x + VERTEX.z + TIME * speed) * frequency);


	// applique le vent uniquement sur Y
    VERTEX.y += wave * amplitude;
	}

void fragment() {
    // Récupération de la texture
    vec3 albedo = texture(albedo_texture, UV).rgb;
	float height_factor = clamp((VERTEX.y + 1.0) / 2.0, 0.0, 1.0);
    vec3 gradient_color = mix(bottom_tint_color, top_tint_color, height_factor);
    ALBEDO = albedo * gradient_color;
}


void light() {
    // Calcul de l'éclairage diffus avec Toon Shading
    float NdotL = max(dot(NORMAL, LIGHT), 0.0);
    float toon_shade = smoothstep(shadow_threshold - shadow_smoothness, shadow_threshold + shadow_smoothness, NdotL);
    vec3 final_color = mix(shadow_color.rgb, light_color.rgb, toon_shade) * ALBEDO;

    // Application de la lumière diffuse
    DIFFUSE_LIGHT += final_color * ATTENUATION;
	 }
