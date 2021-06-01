public class Line {
    boolean creating = true;
    PVector start;
    float len;
    float sizeFactor = 0.0;
    float creatingSpeed = 0.006;
    int moveDown = 120;

    PShape lineShape;
    color scol;
    float swmin = 0.5, swmax = 80.5, swinc = 6.0;
    int iters;
    int cnt;

    int colIndex;
    color[] colors = {
        color(21, 117, 219),  // Blue
        color(255, 123, 0),   // Orange
        color(255, 242, 0),   // Yellow
        color(33, 255, 0),    // Green
        color(241, 53, 255),  // Pink
        color(255, 53, 60)    // Red
    };
    

    Line(PVector start, float len, int colIndex) {
        this.start = start;
        this.len = len;

        this.colIndex = colIndex;
        this.scol = this.colors[colIndex];
        this.iters = (int) ((swmax - swmin) / swinc);
        this.cnt = this.iters;

        
        // this.creatingSpeed = creatingSpeed * 800 / len;
    }

    void render() {
        if (creating) {
            this.sizeFactor += this.creatingSpeed;
            if (this.sizeFactor >= 1) {
                this.sizeFactor = 1;
                this.creating = false;
            }
            this.drawLine(this.len * this.sizeFactor);
        } else {
            this.drawLine(this.len);
        }
    }

    void drawLine(float drawLen) {
        this.iters = (int) ((swmax - swmin) / swinc);
        this.cnt = this.iters;
        lineShape = createShape(LINE, 0, 0, drawLen, 0);
        for (float swcur=swmin; swcur<=swmax; swcur+=swinc) {
            color newScol = colorHSV(scol, cnt--, iters, 2.5);
            lineShape.setStrokeWeight(swcur);
            lineShape.setStroke(newScol);
            shape(lineShape, start.x, start.y);
        }

        lineShape.setStrokeWeight(4);
        lineShape.setStroke(color(234, 244, 255));
        shape(lineShape, start.x, start.y);
    }

    ArrayList<Line> getChildrenLines() {
        ArrayList<Line> childrenLines = new ArrayList<Line>();

        color newColIndex = floor(random(colors.length));
        while (newColIndex == colIndex) {
            newColIndex = floor(random(colors.length));
        }

        childrenLines.add(new Line(
            PVector.add(start, new PVector(0, moveDown)),
            len/3,
            newColIndex
        ));
        childrenLines.add(new Line(
            PVector.add(start, new PVector(len*2/3, moveDown)),
            len/3,
            newColIndex
        ));
        
        return childrenLines;
    }
}

color colorHSV(color col, int cur, int tot, float ramp){
    colorMode(HSB, 360, 100, 100, 100);
    
    float curHue = hue(col);
    float curSat = saturation(col);
    float curVal = brightness(col);
    float curAlpha = alpha(col);

    curSat = lerp(curSat, 10, pow(cur/float(tot), ramp));
    curVal = lerp(curVal, 100, cur/float(tot));
    curAlpha = lerp(1, 25, pow(cur/float(tot), ramp));
    
    color c = color(curHue, curSat, curVal, curAlpha); 
    
    colorMode(RGB, 255, 255, 255, 255); // restore the colorMode
    return c;
}
