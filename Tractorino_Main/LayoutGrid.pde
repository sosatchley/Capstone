class LayoutGrid {
    int windowSize;
    float numberOfColumns;
    float numberOfRows;

    LayoutGrid(int windowSize, int cols, int rows) {
        this.windowSize = windowSize;
        this.numberOfColumns = cols;
        this.numberOfRows = rows;
    }

    PVector getCoords( int columnNumber, int rowNumber, ButtonSize buttonSize) {
        horizontalSpacing = getConrolWidth(buttonSize) / 2;
        verticalSpacing = getControlHeight(buttonSize) / 2;
        float x = getCoordForColumn(colNumber) - horizontalSpacing;
        float y = gettCoordForRow(rowNumber) - verticalSpacing;
        PVector buttonCoords = new PVector(x, y);
        return buttonCoords;
    }

    float getCoordForAxis( int gridNumber) {
        int gridInterval = getGridInterval();
        int columnMiddle = (gridInterval * columnNumber) + (gridInterval / 2);
        return columnMiddle;
    }

    float gettCoordForRow(int rowNumber) {
            float columnWidth = getColumnWidth();
            float columnMiddle = (columnWidth * columnNumber) + (columnWidth / 2);
            return columnMiddle;
        }
    }

    int getConrolWidth(ButtonSize buttonSize) {
        Switch (buttonSize) {
            case ButtonSize.SMALL:
                return smallControlWidth();
            case ButtonSize.MEDIUM:
                return mediumControlWidth();
            case ButtonSize.LARGE:
                return largeControlWidth();
        }
    }

    int getConrolHeight(ButtonSize buttonSize) {
        Switch (buttonSize) {
            case ButtonSize.SMALL:
                return smallControlHeight();
            case ButtonSize.MEDIUM:
                return mediumControlHeight();
            case ButtonSize.LARGE:
                return largeControlHeight();
        }
    }

    int smallControlWidth() {
        return getColumnWidth();
    }

    int mediumControlWidth() {
        return getColumnWidth();
    }

    int largeControlWidth() {
        return getColumnWidth();
    }

    int smallControlWidth() {
        return getColumnWidth();
    }

    int smallControlWidth() {
        return getColumnWidth();
    }

    int smallControlWidth() {
        return getColumnWidth();
    }

    int smallControlWidth() {
        return getColumnWidth();
    }

    int getColumnWidth() {
        return floor(this.windowSize / this.numberOfColumns);
    }
}
