#version 100

varying lowp vec4 vertexColor;

void main() {
    gl_FragColor = vertexColor;
}

