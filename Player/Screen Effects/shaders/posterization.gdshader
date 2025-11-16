shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform int levels : hint_range(1,64) = 4;

vec3 posterize(vec3 c, float lv) {
    return floor(c * lv) / lv;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec3 col = texture(SCREEN_TEXTURE, uv).rgb;

    col = posterize(col, float(levels));

    COLOR = vec4(col, 1.0);
}