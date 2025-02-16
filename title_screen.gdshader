shader_type canvas_item;

// Uniforms
uniform float time;
uniform float spin_time;
uniform vec4 colour_1 : source_color;
uniform vec4 colour_2 : source_color;
uniform vec4 colour_3 : source_color;
uniform float contrast;
uniform float spin_amount;

// Constants
#define PIXEL_SIZE_FAC 700.0
#define SPIN_EASE 0.5

void fragment() {
    // Calculate viewport size and pixel size
    vec2 viewport_size = 1.0 / SCREEN_PIXEL_SIZE;
    float pixel_size = length(viewport_size) / PIXEL_SIZE_FAC;
    
    // Pixelate coordinates
    vec2 uv_pixel = floor(FRAGCOORD.xy * (1.0 / pixel_size)) * pixel_size;
    vec2 uv = (uv_pixel - 0.5 * viewport_size) / length(viewport_size) - vec2(0.12, 0.0);
    float uv_len = length(uv);
    
    // Swirl effect
    float swirl_speed = (spin_time * SPIN_EASE * 0.2) + 302.2;
    float pixel_angle = atan(uv.y, uv.x) + swirl_speed - SPIN_EASE * 20.0 * (spin_amount * uv_len + (1.0 - spin_amount));
    uv = vec2(uv_len * cos(pixel_angle), uv_len * sin(pixel_angle));
    
    // Paint effect
    uv *= 30.0;
    float paint_speed = time * 2.0;
    vec2 uv2 = vec2(uv.x + uv.y);
    
    // Distortion loop
    for(int i = 0; i < 5; i++) {
        uv2 += sin(max(uv.x, uv.y)) + uv;
        uv += 0.5 * vec2(
            cos(5.1123314 + 0.353 * uv2.y + paint_speed * 0.131121),
            sin(uv2.x - 0.113 * paint_speed)
        );
        uv -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
    }
    
    // Color calculation
    float contrast_mod = (0.25 * contrast + 0.5 * spin_amount + 1.2);
    float paint_res = clamp(length(uv) * 0.035 * contrast_mod, 0.0, 2.0);
    
    float c1p = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint_res));
    float c2p = max(0.0, 1.0 - contrast_mod * abs(paint_res));
    float c3p = 1.0 - min(1.0, c1p + c2p);
    
    vec4 ret_col = (0.3 / contrast) * colour_1 
        + (1.0 - 0.3 / contrast) * (
            colour_1 * c1p 
            + colour_2 * c2p 
            + vec4(colour_3.rgb * c3p, colour_1.a * c3p)
        );
    
    COLOR = ret_col;
}