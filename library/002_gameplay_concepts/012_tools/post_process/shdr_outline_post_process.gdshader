shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_always, cull_disabled;

// 📌 Capture des buffers d'écran
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture;

// 🎛️ Paramètres ajustables

uniform float outline_thickness : hint_range(0.001, 0.02) = 0.005; // Épaisseur du contour
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Couleur du contour
uniform float depth_sensitivity : hint_range(0.0, 1.0) = 0.3; // Sensibilité aux différences de profondeur
uniform float normal_sensitivity : hint_range(0.0, 1.0) = 0.3; // Sensibilité aux différences de normales

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;
    float depth = texture(depth_texture, SCREEN_UV).r;

    float depth_x1 = texture(depth_texture, SCREEN_UV + vec2(outline_thickness, 0.0)).r;
    float depth_x2 = texture(depth_texture, SCREEN_UV - vec2(outline_thickness, 0.0)).r;
    float depth_y1 = texture(depth_texture, SCREEN_UV + vec2(0.0, outline_thickness)).r;
    float depth_y2 = texture(depth_texture, SCREEN_UV - vec2(0.0, outline_thickness)).r;

    float depth_edge = abs(depth - depth_x1) + abs(depth - depth_x2) + abs(depth - depth_y1) + abs(depth - depth_y2);

    float edge = step(depth_sensitivity, depth_edge);

    vec3 final_color = mix(color, outline_color.rgb, edge);

    ALBEDO = final_color;
    ALPHA = edge; // ✅ Transparence active : seulement sur les contours
}
