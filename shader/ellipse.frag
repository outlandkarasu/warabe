#version 330 core

in vec4 color;
in vec2 localPosition;
out vec4 fragmentColor;

void main() {
    if(length(vec2(0.5f, 0.5f) - localPosition) > 0.5f) {
        discard;
    }
    fragmentColor = color;
}

