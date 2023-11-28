#include <stdio.h>
#include <stdint.h>
#include <math.h>

#define TABLE_SIZE 360
#define SCALE_FACTOR 32767.0

int16_t sine_table[TABLE_SIZE];

void init_sine_table() {
    for (int i = 0; i < TABLE_SIZE; ++i) {
        sine_table[i] = (int16_t)(sin(i * M_PI / 180.0) * SCALE_FACTOR);
        printf("%d,", sine_table[i]);
    }
}

int16_t fixed_point_sin(int degrees) {
    degrees = degrees % TABLE_SIZE;
    if (degrees < 0) {
        degrees += TABLE_SIZE;
    }

    return sine_table[degrees];
}
