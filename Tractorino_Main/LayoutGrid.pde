class LayoutGrid {
    int windowSize;
    float numberOfColumns;
    float numberOfRows;

    LayoutGrid(int cols, int rows) {
        this.windowSize = verticalResolution;
        this.numberOfColumns = cols;
        this.numberOfRows = rows;
    }

    PVector backButtonPosition() {
        return new PVector(-25, (this.windowSize/10) - (this.windowSize/20));
    }

    PVector backButtonSize() {
        int buttonWidth = this.windowSize/20;
        int buttonHeight = this.windowSize/10;
        return new PVector(buttonWidth, buttonHeight);
    }

    PVector getCoords(int columnNumber, int rowNumber, ButtonSize buttonSize) {
        float horizontalSpacing = getControlWidth(buttonSize) / 2;
        float verticalSpacing = getControlHeight(buttonSize) / 2;
        float x = getCoordForColumn(columnNumber);
        float y = getCoordForRow(rowNumber) - verticalSpacing;
        PVector buttonCoords = new PVector(x, y);
        return buttonCoords;
    }

    float getCoordForColumn(int colNumber) {
        float controlWidth = getControlWidth();
        float whiteSpace = this.windowSize * 0.25;
        float spacing = whiteSpace / (this.numberOfColumns + 1);
        return ((controlWidth * colNumber) + (spacing * (colNumber+1)));
    }

    float getCoordForRow(int rowNumber) {
        int rowHeight = (int)getRowHeight();
        int rowMiddle = (rowHeight * rowNumber) + (rowHeight / 2);
        return rowMiddle;
    }

    int getControlWidth() {
        return floor(largeControlWidth());
    }

    int getControlWidth(ButtonSize buttonSize) {
        switch(buttonSize) {
            case SMALL:
                return floor(smallControlWidth());
            case MEDIUM:
                return floor(mediumControlWidth());
            case LARGE:
                return floor(largeControlWidth());
            default:
                return 100;
        }
    }

    int getControlHeight(ButtonSize buttonSize) {
        switch(buttonSize) {
            case SMALL:
                return floor(smallControlHeight());
            case MEDIUM:
                return floor(mediumControlHeight());
            case LARGE:
                return floor(largeControlHeight());
            default:
                return 50;
        }
    }

    float smallControlWidth() {
        return getColumnWidth()/10;
    }

    float mediumControlWidth() {
        return getColumnWidth()/5;
    }

    float largeControlWidth() {
        return getColumnWidth() * 0.75;
    }

    float smallControlHeight() {
        return getRowHeight()/10;
    }

    float mediumControlHeight() {
        return getRowHeight()/5;
    }

    float largeControlHeight() {
        return getRowHeight()/2;
    }

    float getRowHeight() {
        return floor((this.windowSize/5) / this.numberOfRows);
    }

    float getColumnWidth() {
        return floor((this.windowSize) / this.numberOfColumns);
    }
}
