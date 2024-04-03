shader_type spatial;

render_mode blend_add;

uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	METALLIC = 0.0;
	ROUGHNESS = 0.0;
	ALBEDO = vec3(255, 0, 0);
	vec3 world_position = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALPHA = 0.05 * (1.0 - (length(VERTEX)*length(VERTEX) / 200.0));
	EMISSION = vec3(10.0, 0.0, 0.0);
	vec4 v = texture(noise, (VIEW_MATRIX * vec4(VERTEX,1.0)).xz);
	ALPHA = ALPHA * length(v.xyz);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
