shader_type spatial;
render_mode blend_mix,cull_back, depth_draw_opaque,unshaded,specular_toon;
uniform float roughness : hint_range(0.0, 1.0, 0.1);

uniform vec3 base_couleur :source_color;
uniform vec3 highlitgh_color : source_color;
uniform float highlight_largeur : hint_range(0.0, 1.0) = 0.2;
uniform float highlight_douceur : hint_range(0.0, 1.0) = 0.2;
uniform vec3 emission_color : source_color;
uniform float alpha :hint_range(0.0, 1.0, 0.1);
uniform float emissive : hint_range(0.0, 1.0, 0.1);
uniform float  intensity_move;// definis l'intensité du mouvement un peu comme un radius
uniform float speed; // definis le speed du mouvment  
uniform float noise_scale; // vas servir comme donné pour crée les déplacemnt des point
//uniform float fresnel_power : hint_range(1.0, 10.00) =3.0;
//uniform float fresnel_strength : hint_range(0.0, 2.0)=1.0;

//uniform sampler2D noise_texture;
//uniform float edge_01 : hint_range(0.0, 1.0, 0.1);
//uniform float edge_02 : hint_range(0.0, 1.0, 0.1);




void vertex() {
	// La logique ici c'est de créer un mouvment aléatoire pour donner un effet de noise 
	// pour ça on va créer trois vague différent avec des vitesse différent 
	//ça va donner un coté aléatoire, 
	//pour le mouvement de va et viens on va utiliser les formule sin() et cos()
	float wave_x = sin(VERTEX.x * noise_scale + TIME * speed);// mouvement sur l'axe x
	float wave_z = cos(VERTEX.z * noise_scale + TIME * speed * 1.3);// mouvement sur l'axe y
	float wave_y = sin(VERTEX.y  * noise_scale * 0.5 + TIME * speed * 0.8); // mouvement sur l'axe z
	float waves = wave_x + wave_z + wave_y;// on rerajoute les axes ensemble
	
	// ici on redivise le resultat des axe par 3 donc on multiplie par 0.33
	float deform = waves * 0.33 * intensity_move; 
	VERTEX += NORMAL * deform; // si on utilise pas NORMAL le mouvement
	//se fera uniquement que dans une direction 
	
	
	
	
	
//	Test avec une texture de bruit : cool mais demande plus de parametre pour un effet smooth 
	//vec3 noise = texture(noise_texture, UV).rgb;
	//vec3 smooth_noise = smoothstep(edge_01,edge_02,noise);
	////float wave_x =sin(VERTEX.x * TIME * speed);
	//float wave = sin(VERTEX * TIME * speed).x;
	//float deform = wave *  smooth_noise.r * 0.33  * intensity_move;
	//VERTEX+= NORMAL * deform;
}

void fragment() {
    vec3 view_dir = normalize(-VIEW);
    float fresnel_raw = 1.0 - dot(NORMAL, view_dir);


    float rim = smoothstep(highlight_largeur - highlight_douceur,highlight_largeur,fresnel_raw);
	vec3 couleur = mix(base_couleur,highlitgh_color,rim);
    ALBEDO = couleur;
    ALPHA = alpha;
    EMISSION = emission_color * rim * emissive;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
