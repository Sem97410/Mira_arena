shader_type spatial;


// Paramètre contrôlable dans l'inspecteur Godot (slider de 0 à 1)
// Il règle l'intensité du mouvement (gonflement)
uniform float intensity_move : hint_range(0.0, 1.0); 

// Vitesse globale de l’animation
uniform float speed = 1.0;

// Densité des vagues (plus haut = plus serré)
uniform float noise_scale = 2.0;

void vertex() {
    // On additionne 3 vagues différentes (une par axe) pour créer un effet organique

    // Vague selon X (position horizontale)
    float wave_x = sin(VERTEX.x * noise_scale + TIME * speed);

    // Vague selon Z (position en profondeur), avec une vitesse un peu différente pour désynchroniser
    float wave_z = cos(VERTEX.z * noise_scale + TIME * speed * 1.3);

    // Vague selon Y (position verticale), avec un "zoom arrière" (0.5) pour un mouvement plus lent et large
    float wave_y = sin(VERTEX.y * noise_scale * 0.5 + TIME * speed * 0.8);

    // Somme des 3 ondes pour un mouvement fluide et vivant
    float offset = wave_x + wave_z + wave_y;

    // On réduit un peu l’effet global (0.33 ≈ moyenne de 3 valeurs entre -1 et 1)
    // Puis on applique l’intensité contrôlable
    float deform = offset * 0.33 * intensity_move;

    // On déplace le vertex le long de sa normale (gonflement vers l'extérieur)
    VERTEX += NORMAL * deform;
}
void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
