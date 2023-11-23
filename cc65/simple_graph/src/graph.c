#include <stdlib.h>
#include <atari.h>

int main(void) {
    int x;
    _graphics(8);
    _setcolor(1,1,14);
    _color(1);

    for(x=0; x<100;x++) {
        _plot(x,0);
        _drawto(x,191);
    }

    return EXIT_SUCCESS;
}