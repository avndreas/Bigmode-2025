shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float dither_intensity : hint_range(0.0, 1.0) = 1.0;
uniform vec3 color_depth = vec3(4.0, 4.0, 4.0); // Reduce to 4-bit for each channel

// Bayer matrix (4x4) represented with vec4s
const vec4 bayer_row1 = vec4(1.0 / 16.0, 9.0 / 16.0, 3.0 / 16.0, 11.0 / 16.0);
const vec4 bayer_row2 = vec4(13.0 / 16.0, 5.0 / 16.0, 15.0 / 16.0, 7.0 / 16.0);
const vec4 bayer_row3 = vec4(4.0 / 16.0, 12.0 / 16.0, 2.0 / 16.0, 10.0 / 16.0);
const vec4 bayer_row4 = vec4(16.0 / 16.0, 8.0 / 16.0, 14.0 / 16.0, 6.0 / 16.0);

void fragment() {
    // Screen space coordinates
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;

    // Sample the screen texture using the new 'screen_texture' uniform
    vec4 color = texture(screen_texture, SCREEN_UV);

    // Bayer dithering: Determine which element of the Bayer matrix to use
    int bx = int(mod(FRAGCOORD.x, 4.0)); // x coordinate in the Bayer matrix
    int by = int(mod(FRAGCOORD.y, 4.0)); // y coordinate in the Bayer matrix

    // Get the threshold from the Bayer matrix based on the current pixel's position
    float threshold;
    if (by == 0) {
        threshold = bayer_row1[bx];
    } else if (by == 1) {
        threshold = bayer_row2[bx];
    } else if (by == 2) {
        threshold = bayer_row3[bx];
    } else {
        threshold = bayer_row4[bx];
    }

    // Quantize each color channel
    vec3 quantized_color = floor(color.rgb * color_depth + threshold * dither_intensity) / color_depth;

    // Set the final color
    COLOR = vec4(quantized_color, color.a);
}