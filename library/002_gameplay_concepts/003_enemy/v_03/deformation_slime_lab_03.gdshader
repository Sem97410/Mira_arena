shader_type spatial;
render_mode specular_toon,unshaded;
uniform vec3 top_color: source_color; 
uniform vec3 base_color: source_color;
uniform float roughness : hint_range(0.0, 1.0, 0.1);

// Texture animée pour effet de flamme
uniform sampler2D flame_tex;
uniform float flame_speed = 0.5;
uniform float flame_scale = 1.0;
uniform float flame_influence = 0.5;

 
uniform float intensity_alpha :hint_range(0.0, 1.0, 0.1);
uniform float  intensity_move;// definis l'intensité du mouvement un peu comme un radius
uniform float speed; // definis le speed du mouvment  
uniform float noise_scale; // vas servir comme donné pour crée les déplacemnt des points
uniform float height_min;
uniform float height_max;
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
	
	// gradient vertical
	float axe_y = VERTEX.y;
	float axe_y_clamp =clamp((axe_y + height_min)/(height_min - height_max),0.0,1.0);
	vec3 couleur = mix(top_color,base_color,axe_y_clamp);
	
	
		//texture animé
	vec2 uv_anim = UV;
	uv_anim.y += TIME * flame_speed;
	vec3 flamme_mask = texture(flame_tex,uv_anim,flame_scale).xyz;
	
	vec3 final_color = mix(couleur,vec3(1.0),flamme_mask.r * flame_influence);
	
	ALBEDO =  final_color;
	ALPHA = intensity_alpha;
	SPECULAR = 1.0;
	

	
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
