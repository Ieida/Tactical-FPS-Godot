shader_type spatial;

render_mode blend_add;

uniform sampler2D tex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	METALLIC = 0.0;
	ROUGHNESS = 0.0;
	ALBEDO = vec3(255, 0, 0);
	vec3 world_position = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALPHA = 1.0 * (1.0 - (length(world_position) / 100.0));
	vec4 tx = texture(tex, UV);
	ALPHA = ALPHA * tx.a;
	EMISSION = vec3(10.0, 0.0, 0.0);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
