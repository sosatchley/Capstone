// class Util() {
//
//     Util() {}

    String coord(float x, float y) {
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    String coord(PVector vector) {
        float x = vector.x;
        float y = vector.y;
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    void drawGrid(int cellSize) {
        PFont font = createFont("Georgia", 8);
        textFont(font);
        for (float y = 0; y < height; y+=cellSize) {
            for (float x = 0; x < width; x+=cellSize) {
                line(x,y, x, y+cellSize);
                line(x,y, x+cellSize, y);
                text(coord(x, y), x+1, y+1);
            }
        }
    }
