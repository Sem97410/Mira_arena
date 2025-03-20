shader_type spatial;

render_mode cull_disabled , diffuse_toon, specular_toon, unshaded;
uniform sampler2D gradient;
uniform vec3 light_color : source_color;
uniform vec3 base_color : source_color;
uniform sampler2D noise;
uniform float x_mouvement_strength;
uniform float z_mouvement_strength;
uniform float wind_force;



void vertex() {
	
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float axe_y = world_position.y;
	float direction_axe_y = clamp(axe_y/2.0, 0.0, 1.0);
	float animation_wind_x = sin(TIME + world_position.x * x_mouvement_strength);
	float animation_wind_z = sin(TIME + world_position.x * z_mouvement_strength);
	VERTEX.xz += animation_wind_x* animation_wind_z * direction_axe_y * wind_force;


	
	
}

void fragment() {
	float vertical_factor = clamp(UV.y, 0.0, 1.0);
	vec3 gradient_texture =  texture(gradient, UV).xyz;
	ALBEDO= mix(light_color,base_color,UV.y) * mix(light_color,base_color,gradient_texture);
	
	
	if(!FRONT_FACING){
		NORMAL = -NORMAL;
	}
	
	
	
}


//void light() {
 
//}


