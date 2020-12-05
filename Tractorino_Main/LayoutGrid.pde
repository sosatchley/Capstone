class LayoutGrid {
    int windowSize;
    float numberOfColumns;
    float numberOfRows;

    LayoutGrid(int windowSize, int cols, int rows) {
        this.windowSize = windowSize;
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
        float x = getCoordForColumn(columnNumber) - horizontalSpacing;
        float y = getCoordForRow(rowNumber) - verticalSpacing;
        PVector buttonCoords = new PVector(x, y);
        return buttonCoords;
    }

    float getCoordForColumn(int colNumber) {
        int columnWidth = getColumnWidth();
        int columnMiddle = (columnWidth * colNumber) + (columnWidth / 2);
        return columnMiddle;
    }

    float getCoordForRow(int rowNumber) {
        int rowHeight = getRowHeight();
        int rowMiddle = (rowHeight * rowNumber) + (rowHeight / 2);
        return rowMiddle;
    }

    int getControlWidth(ButtonSize buttonSize) {
        switch(buttonSize) {
            case SMALL:
                return smallControlWidth();
            case MEDIUM:
                return mediumControlWidth();
            case LARGE:
                return largeControlWidth();
            default:
                return 100;
        }
    }

    int getControlHeight(ButtonSize buttonSize) {
        switch(buttonSize) {
            case SMALL:
                return smallControlHeight();
            case MEDIUM:
                return mediumControlHeight();
            case LARGE:
                return largeControlHeight();
            default:
                return 50;
        }
    }

    int smallControlWidth() {
        return getColumnWidth()/10;
    }

    int mediumControlWidth() {
        return getColumnWidth()/5;
    }

    int largeControlWidth() {
        return getColumnWidth()/2;
    }

    int smallControlHeight() {
        return getRowHeight()/10;
    }

    int mediumControlHeight() {
        return getRowHeight()/5;
    }

    int largeControlHeight() {
        return getRowHeight()/2;
    }

    int getRowHeight() {
        return floor((this.windowSize/5) / this.numberOfRows);
    }

    int getColumnWidth() {
        return floor((this.windowSize) / this.numberOfColumns);
    }
}
