shader_type spatial;

void fragment() {
    if (dot(NORMAL, VIEW) < 0.0) {
        ALBEDO = vec3(1.0, 0.0, 0.0); // Change la couleur du personnage s'il est derrière un mur
        EMISSION = vec3(1.0); // Ajoute une lueur
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
