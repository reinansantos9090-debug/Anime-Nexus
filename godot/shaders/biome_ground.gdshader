shader_type spatial;
render_mode diffuse_toon, specular_disabled;

uniform vec4 base_color : source_color = vec4(0.20, 0.42, 0.30, 1.0);
uniform vec4 accent_color : source_color = vec4(0.30, 0.55, 0.42, 1.0);
uniform float variation_strength : hint_range(0.0, 0.45, 0.01) = 0.18;
uniform float pattern_scale : hint_range(0.02, 1.0, 0.01) = 0.16;

varying vec3 terrain_world_position;

float hash_cell(vec2 cell) {
    return fract(sin(dot(cell, vec2(127.1, 311.7))) * 43758.5453123);
}

float value_noise(vec2 position) {
    vec2 cell = floor(position);
    vec2 fraction = fract(position);
    fraction = fraction * fraction * (3.0 - 2.0 * fraction);
    float a = hash_cell(cell);
    float b = hash_cell(cell + vec2(1.0, 0.0));
    float c = hash_cell(cell + vec2(0.0, 1.0));
    float d = hash_cell(cell + vec2(1.0, 1.0));
    return mix(mix(a, b, fraction.x), mix(c, d, fraction.x), fraction.y);
}

void vertex() {
    terrain_world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec2 coordinates = terrain_world_position.xz * pattern_scale;
    float broad = value_noise(coordinates);
    float detail = value_noise(coordinates * 3.1);
    float grain = broad * 0.72 + detail * 0.28;
    float patches = smoothstep(0.28, 0.80, grain) * variation_strength;
    ALBEDO = mix(base_color.rgb, accent_color.rgb, patches);
    ROUGHNESS = 0.96;
    METALLIC = 0.0;
}
