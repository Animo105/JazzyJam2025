shader_type canvas_item;
uniform float percentOffsetY = 0;
uniform sampler2D texture_splat;

void vertex() {
	ivec2 size = textureSize(texture_splat, 1);
	VERTEX.y += (float(size.y)*percentOffsetY);
}

void fragment() {

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
