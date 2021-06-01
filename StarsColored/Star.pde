public class Star {
    boolean creating = true;
    PVector center;
    float length;
    int numVertex;
    float thickness;
    float sizeFactor = 0.0;
    float creatingSpeed = 0.02;
    float sectionAngle;
    PVector[] largeVertices;
    PVector[] smallVertices;
    PShape shape;
    float shapeHeight;
    float shapeWidth;

    PShape lineShape;
    color scol;
    float swmin = 0.5, swmax = 30.5, swinc = 5.0;
    int iters;
    int cnt;

    color colStroke;
    color colGlow;
    color colFill;
    int nextColorIndex;
    // color[] colorsStroke = {
    //     color(160, 255, 176),  // Green
    //     color(193, 193, 255), // Blue
    //     color(255, 163, 163), // Red
    //     color(255, 255, 181),    // Yelllow
    //     color(238, 163, 255),    // Purple
    //     color(255, 188, 150)   // Orange
    // };
    // color[] colorsGlow = {
    //     color(63, 255, 53),   // Green
    //     color(53, 53, 255),  // Blue
    //     color(255, 53, 53),  // Red
    //     color(255, 255, 53),    // Yelllow
    //     color(244, 53, 255),    // Purple
    //     color(255, 127, 22)   // Orange
    // };
    // color[] colorsFill = {
    //     color(63, 255, 53, 120),   // Green
    //     color(53, 53, 255, 120),  // Blue
    //     color(255, 53, 53, 120),  // Red
    //     color(255, 255, 53, 120),    // Yelllow
    //     color(244, 53, 255, 120),    // Purple
    //     color(255, 127, 22, 120)   // Orange
    // };
    color[] colorsStroke = {
        color(255, 84, 84),
        color(211, 255, 145),
        color(255, 226, 114),
        color(142, 142, 255)
    };
    color[] colorsGlow = {
        color(204, 0, 0),
        color(153, 255, 0),
        color(255, 204, 0),
        color(51, 51, 255)
    };
    color[] colorsFill = {
        color(204, 0, 0, 120),
        color(153, 255, 0, 120),
        color(255, 204, 0, 120),
        color(51, 51, 255, 120)
    };
    

    Star(PVector center, float length, int numVertex, float thickness, int colIndex) {
        this.length = length;
        this.center = center;
        this.numVertex = numVertex;
        this.thickness = thickness;
        this.sectionAngle = 2 * PI / numVertex;
        this.largeVertices = new PVector[numVertex];
        this.smallVertices = new PVector[numVertex];
        this.shape = createShape();
        this.shape.beginShape();
        for (int i = 0; i < numVertex; i++) {
            largeVertices[i] = new PVector(
                sin(sectionAngle*(i-1) + sectionAngle), 
                cos(sectionAngle*(i-1) + sectionAngle)
            ).mult(length);
            this.shape.vertex(largeVertices[i].x, largeVertices[i].y);
            smallVertices[i] = new PVector(
                sin(sectionAngle*i + sectionAngle/2), 
                cos(sectionAngle*i + sectionAngle/2)
            ).mult(thickness*length);
            this.shape.vertex(smallVertices[i].x, smallVertices[i].y);
        }
        this.shape.endShape(CLOSE);
        this.shapeHeight = this.shape.height;
        this.shapeWidth = this.shape.width;
        this.shape.setFill(colorsFill[colIndex]);
        this.shape.setStroke(color(0,0));

        // this.scol = scol;
        this.iters = (int) ((swmax - swmin) / swinc);
        this.cnt = this.iters;

        this.colStroke = colorsStroke[colIndex];
        this.scol = colorsGlow[colIndex];
        this.colFill = colorsFill[colIndex];
        if (colIndex + 1 == this.colorsFill.length) {
            this.nextColorIndex = 0;
        } else {
            this.nextColorIndex = colIndex+1;
        }


    }

    void render() {
        if (creating) {
            this.sizeFactor += this.creatingSpeed;
            if (this.sizeFactor >= 1.0) {
                this.sizeFactor = 1.0;
                this.creating = false;
            }

            PVector[] tempLargeVertices = new PVector[numVertex];
            PVector[] tempSmallVertices = new PVector[numVertex];
            for (int i = 0; i < numVertex; i++) {
                tempLargeVertices[i] = PVector.mult(largeVertices[i], this.sizeFactor);
                tempSmallVertices[i] = PVector.mult(smallVertices[i], this.sizeFactor);
            }
            
            pushMatrix();
            translate(center.x, center.y);
            shape(this.shape, 0, 0, shapeWidth*sizeFactor, shapeHeight*sizeFactor);
            for (int i = 0; i < numVertex; i++) {
                drawLine(tempLargeVertices[i].x, tempLargeVertices[i].y,
                         tempSmallVertices[i].x, tempSmallVertices[i].y);
                if (i != numVertex - 1) {
                    drawLine(tempSmallVertices[i].x, tempSmallVertices[i].y,
                             tempLargeVertices[i+1].x, tempLargeVertices[i+1].y);
                } else {
                    drawLine(tempSmallVertices[i].x, tempSmallVertices[i].y,
                             tempLargeVertices[0].x, tempLargeVertices[0].y);
                }
            }
            popMatrix();
        } else {
            pushMatrix();
            translate(center.x, center.y);
            shape(this.shape, 0, 0, shapeWidth, shapeHeight);
            for (int i = 0; i < numVertex; i++) {
                drawLine(largeVertices[i].x, largeVertices[i].y,
                         smallVertices[i].x, smallVertices[i].y);
                if (i != numVertex - 1) {
                    drawLine(smallVertices[i].x, smallVertices[i].y,
                             largeVertices[i+1].x, largeVertices[i+1].y);
                } else {
                    drawLine(smallVertices[i].x, smallVertices[i].y,
                             largeVertices[0].x, largeVertices[0].y);
                }
            }
            popMatrix();
        }
    }

    void drawLine(float x, float y, float xx, float yy) {
        this.iters = (int) ((swmax - swmin) / swinc);
        this.cnt = this.iters;
        for (float swcur=swmin; swcur<=swmax; swcur+=swinc) {
            color newScol = colorHSV(scol, cnt--, iters, 2.5);
            strokeWeight(swcur);
            stroke(newScol);
            line(x, y, xx, yy);
        }

        strokeWeight(2);
        stroke(colStroke);
        line(x, y, xx, yy);
    }

    ArrayList<Star> getChildrenStars() {
        ArrayList<Star> childrenStars = new ArrayList<Star>();

        for (int i = 0; i < numVertex; ++i) {
            childrenStars.add(new Star(
                PVector.add(center, this.largeVertices[i]),
                length*reductionFactor,
                numVertex, thickness, nextColorIndex
            ));
        }

        return childrenStars;
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
