shader_type canvas_item;

// 📌 Capture la scène en tant que texture
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// 🎛️ Paramètres du Bloom / Glow
uniform float bloom_intensity : hint_range(0.0, 2.0) = 1.0; // Force du bloom
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.7; // Niveau de luminosité
uniform float blur_size : hint_range(0.001, 0.02) = 0.005; // Taille du flou

// 🎛️ Paramètres du Noise (Grain)
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.05; // Force du grain
uniform float noise_speed : hint_range(0.1, 5.0) = 1.0; // Animation du bruit

void fragment() {
    // 🌟 Capture la scène
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;

    // 🎯 Détection des hautes lumières (Bloom)
    vec3 bloom_color = max(color - bloom_threshold, 0.0);

    // 🔥 Appliquer un flou léger pour lisser le Bloom
    vec3 blurred = (
        texture(screen_texture, SCREEN_UV + vec2( blur_size,  blur_size)).rgb +
        texture(screen_texture, SCREEN_UV + vec2(-blur_size,  blur_size)).rgb +
        texture(screen_texture, SCREEN_UV + vec2( blur_size, -blur_size)).rgb +
        texture(screen_texture, SCREEN_UV + vec2(-blur_size, -blur_size)).rgb
    ) / 4.0;

    // 🎆 Mélange de l’image originale et du Bloom
    vec3 final_color = color + blurred * bloom_color * bloom_intensity;

    // 🎞️ Génération du bruit aléatoire (Noise)
    float noise = fract(sin(dot(SCREEN_UV * vec2(12.9898, 78.233) + TIME * noise_speed, vec2(34.123, 45.456))) * 43758.5453);

    // 🖌️ Appliquer le grain à l’image finale
    final_color += (noise - 0.5) * noise_intensity;

    // 🎬 Sortie finale avec Glow + Grain
    COLOR = vec4(final_color, 1.0);
}
