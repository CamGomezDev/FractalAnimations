public class KochLine {
    boolean creating = true;
    PVector start;
    PVector end;
    float length;
    float angle = PI / 3;
    float subLineLength;
    float growFactor = 0;
    float growSpeed = 0.012;
    boolean moveStart;
    boolean moveEnd;
    PVector movedPointOrigin;

    color col;
    int nextColorIndex;
    color nextCol;
    color[] colors = {
        // color(255, 68, 68),
        color(89, 150, 255),  // Blue
        color(255, 123, 0),   // Orange
        color(255, 242, 0),   // Yellow
        color(33, 255, 0),    // Green
        color(241, 53, 255),  // Pink
        color(255, 53, 60)    // Red
    };
    boolean changeColors;

    KochLine(PVector start, PVector end, int colorIndex, boolean changeColors) {
        this.start = start;
        this.end = end;
        this.length = PVector.sub(end, start).mag();
        this.subLineLength = (length / (2 + 2 * sin(this.angle / 2)));
        this.creating = false;
        this.col = this.colors[colorIndex];
        if (changeColors) {
            if (colorIndex + 1 == this.colors.length) {
                this.nextColorIndex = 0;
                this.nextCol = this.colors[0];
            } else {
                this.nextColorIndex = colorIndex+1;
                this.nextCol = this.colors[colorIndex+1];
            }
        } else {
            this.nextColorIndex = colorIndex;
        }
        this.changeColors = changeColors;
    }

    KochLine(PVector start, PVector end, boolean moveStart, 
             boolean moveEnd, PVector movedPointOrigin, int colorIndex, 
             boolean changeColors) {
        this.start = start;
        this.end = end;
        this.length = PVector.sub(end, start).mag();
        this.subLineLength = (length / (2 + 2 * sin(this.angle / 2)));
        this.movedPointOrigin = movedPointOrigin;
        this.moveEnd = moveEnd;
        this.moveStart = moveStart;
        this.col = this.colors[colorIndex];
        if (changeColors) {
            if (colorIndex + 1 == this.colors.length) {
                this.nextColorIndex = 0;
                this.nextCol = this.colors[0];
            } else {
                this.nextColorIndex = colorIndex+1;
                this.nextCol = this.colors[colorIndex+1];
            }
        } else {
            this.nextColorIndex = colorIndex;
        }
        this.changeColors = changeColors;
    }

    void render() {
        growFactor += growSpeed;
        if (growFactor >= 1) {
            growFactor = 1;
            creating = false;
        }
        if (changeColors) {
            stroke(lerpColor(this.col, this.nextCol, growFactor));
        } else {
            stroke(this.col);
        }
        if (creating) {
            if (moveEnd) {
                PVector newEnd = PVector.add(
                    movedPointOrigin, 
                    PVector.sub(end, movedPointOrigin).mult(growFactor)
                );
                line(start.x, start.y, newEnd.x, newEnd.y);
            } else if (moveStart) {
                PVector newStart = PVector.add(
                    movedPointOrigin, 
                    PVector.sub(start, movedPointOrigin).mult(growFactor)
                );
                line(newStart.x, newStart.y, end.x, end.y);
            }
        } else {
            line(start.x, start.y, end.x, end.y);
        }
    }

    ArrayList<KochLine> createChildrenKochLines() {
        ArrayList<KochLine> subLines = new ArrayList<KochLine>();
        PVector subLinesVector = PVector.sub(end, start).setMag(subLineLength);
        PVector firstPoint = start;
        PVector secondPoint = PVector.add(start, subLinesVector);
        PVector middlePoint = PVector.add(
            start, PVector.sub(end, start).setMag(length / 2)
        );
        PVector thirdPoint = PVector.add(
            secondPoint, subLinesVector.copy().rotate(-(PI - angle)/2)
        );
        PVector fourthPoint = PVector.sub(end, subLinesVector);
        PVector fifthPoint = end;
        subLines.add(new KochLine(firstPoint, secondPoint, nextColorIndex, changeColors));
        subLines.add(new KochLine(secondPoint, thirdPoint, false, true, middlePoint, nextColorIndex, changeColors));
        subLines.add(new KochLine(thirdPoint, fourthPoint, true, false, middlePoint, nextColorIndex, changeColors));
        subLines.add(new KochLine(fourthPoint, fifthPoint, nextColorIndex, changeColors));

        return subLines;
    }
}
