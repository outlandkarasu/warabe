#version 110

attribute mediump vec3 position;
attribute lowp vec4 color;
uniform mediump mat4 viewport;

varying lowp vec4 vertexColor;

void main() {
    gl_Position = viewport * vec4(position, 1.0f);
    vertexColor = color;
}

