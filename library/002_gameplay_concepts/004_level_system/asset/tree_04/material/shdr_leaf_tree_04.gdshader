shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform sampler2D albedo_texture ;
uniform sampler2D alpha_texture ;
uniform sampler2D normal_texture ;
uniform vec4 shadow_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 light_color : source_color = vec4(1.0, 0.9, 0.8, 1.0);
uniform float shadow_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float shadow_smoothness : hint_range(0.0, 0.5) = 0.1;
uniform float amplitude : hint_range(0.0, 1.0) = 0.1;
uniform float frequency : hint_range(0.0, 10.0) = 2.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;

void vertex() {
 // crée une vague sinusoïdale basée sur la position en X et Z
    float wave = sin((VERTEX.x + VERTEX.z + TIME * speed) * frequency);
	// applique le vent uniquement sur Y
    VERTEX.y += wave * amplitude;
}

void fragment() {

	vec3 albedo = texture(albedo_texture, UV).rgb;
	float alpha = texture(alpha_texture, UV).r;
	vec3 normal_map = texture(normal_texture, UV).rgb;
	NORMAL = normalize(normal_map * 2.0 - 1.0); // Décompression
    ALBEDO = albedo;
	ALPHA = alpha;

	// Called for every pixel the material is visible on.
}

void light() {
    // Calcul de l'éclairage diffus avec Toon Shading
    float NdotL = max(dot(NORMAL, LIGHT), 0.0);
    float toon_shade = smoothstep(shadow_threshold - shadow_smoothness, shadow_threshold + shadow_smoothness, NdotL);
    vec3 final_color = mix(shadow_color.rgb, light_color.rgb, toon_shade) * ALBEDO;

    // Application de la lumière diffuse
    DIFFUSE_LIGHT += final_color * ATTENUATION;
}
