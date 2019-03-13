#version 330 core

layout(location = 0) in vec3 vertexPosition;
layout(location = 1) in vec4 vertexColor;
layout(location = 2) in vec2 vertexLocalPosition;
uniform mat4 viewport;

out vec4 color;
out vec2 localPosition;

void main() {
    gl_Position = viewport * vec4(vertexPosition, 1.0f);
    color = vertexColor;
    localPosition = vertexLocalPosition;
}

