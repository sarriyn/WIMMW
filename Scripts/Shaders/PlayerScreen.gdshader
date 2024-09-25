shader_type spatial;

uniform float flicker_speed : hint_range(0.0, 10.0, 0.1) = 2.0;
uniform vec3 pink_color = vec3(1.0, 2.2, 2.6); // Pink color for emissive

void fragment() {
    // Flicker effect using sine function based on time
    float flicker = 0.5 + 0.5 * sin(TIME * flicker_speed);
    
    // Emissive color with flickering effect
    vec3 emissive_color = pink_color * flicker;
    
    // Output the emissive color
    EMISSION = emissive_color;
    ALBEDO = vec3(0.0);  // No diffuse color for a purely emissive effect
}

void light() {
    // Dynamic light interaction
    vec3 light_color = vec3(1.0); // White light color
    DIFFUSE_LIGHT += light_color * flicker_speed;
}
