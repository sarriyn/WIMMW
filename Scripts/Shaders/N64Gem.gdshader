shader_type spatial;
render_mode diffuse_lambert_wrap, specular_disabled;


group_uniforms common;

uniform vec4 color : source_color = vec4(1.0);
uniform float metalness : hint_range(0.0,1.0) = 1.0;
// the emission alpha determines its power
uniform vec4 emission : source_color;

group_uniforms lighting;
uniform float lighting_power : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform sampler2D lighting_map : source_color, hint_default_black;

group_uniforms reflection;
uniform sampler2D reflected_map;
uniform float reflected_map_power : hint_range(0.0, 1.0, 0.01) = 0.4;


group_uniforms refraction;

uniform bool use_refraction = false;
uniform sampler2D screen_texture : hint_screen_texture, repeat_enable;
uniform float refraction_amount = 0.05;
 // the screen texture map is sometimes way too dull so you can adj the brighness with this
uniform float refraction_brightness = 0.1;

void fragment() {
	
	// matcap implimentation from: https://godotshaders.com/shader/view-matcap/
	vec2 matcap_uv = (NORMAL.xy * vec2(0.5, -0.5) + vec2(0.5, 0.5));
	
	ALBEDO = color.rgb;
	
	vec2 reflected_uv;
	
	// - Refraction
	if (use_refraction) {
		// refraction shader from https://godotshaders.com/shader/3d-low-distortion-refraction-low-poly-glass/
		vec3 normx = NORMAL;
		vec2 displacement = vec2(refraction_amount);
		displacement.x *= -normx.x*2.0;
		displacement.y *= -normx.y*2.0;
		
		reflected_uv = SCREEN_UV + displacement;
		
		ALBEDO *= pow(texture(screen_texture, reflected_uv).rgb + refraction_brightness, vec3(reflected_map_power));
	}
	// - Reflection
	reflected_uv = matcap_uv - UV;
	ALBEDO *= pow(texture(reflected_map, reflected_uv).rgb, vec3(reflected_map_power));
	
	
	// - Lighting
	ALBEDO *= mix(vec3(1.0), pow(texture(lighting_map, matcap_uv).rgb, vec3(lighting_power)), metalness);

}
	
void light()
{
	DIFFUSE_LIGHT = emission.rgb * emission.a;
}
	