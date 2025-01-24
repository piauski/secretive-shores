shader_type canvas_item;

uniform float desaturate_amount : hint_range(0, 1) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec3 gray = vec3(dot(color.rgb, vec3(0.2126, 0.7152, 0.0722)));
    COLOR = vec4(mix(color.rgb, gray, desaturate_amount), color.a);
}