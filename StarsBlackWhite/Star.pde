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

    Star(PVector center, float length, int numVertex, float thickness) {
        this.length = length;
        this.center = center;
        this.numVertex = numVertex;
        this.thickness = thickness;
        this.sectionAngle = 2 * PI / numVertex;
        this.largeVertices = new PVector[numVertex];
        this.smallVertices = new PVector[numVertex];
        for (int i = 0; i < numVertex; i++) {
            largeVertices[i] = new PVector(
                sin(sectionAngle*(i-1) + sectionAngle), 
                cos(sectionAngle*(i-1) + sectionAngle)
            ).mult(length);
            smallVertices[i] = new PVector(
                sin(sectionAngle*i + sectionAngle/2), 
                cos(sectionAngle*i + sectionAngle/2)
            ).mult(thickness*length);
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
            for (int i = 0; i < numVertex; i++) {
                line(tempLargeVertices[i].x, tempLargeVertices[i].y,
                     tempSmallVertices[i].x, tempSmallVertices[i].y);
                if (i != numVertex - 1) {
                    line(tempSmallVertices[i].x, tempSmallVertices[i].y,
                         tempLargeVertices[i+1].x, tempLargeVertices[i+1].y);
                } else {
                    line(tempSmallVertices[i].x, tempSmallVertices[i].y,
                         tempLargeVertices[0].x, tempLargeVertices[0].y);
                }
            }
            popMatrix();
        } else {
            pushMatrix();
            translate(center.x, center.y);
            for (int i = 0; i < numVertex; i++) {
                line(largeVertices[i].x, largeVertices[i].y,
                     smallVertices[i].x, smallVertices[i].y);
                if (i != numVertex - 1) {
                    line(smallVertices[i].x, smallVertices[i].y,
                         largeVertices[i+1].x, largeVertices[i+1].y);
                } else {
                    line(smallVertices[i].x, smallVertices[i].y,
                         largeVertices[0].x, largeVertices[0].y);
                }
            }
            popMatrix();
        }
    }

    PVector[] getCorners() {
        PVector[] corners = new PVector[numVertex];
        for (int i = 0; i < numVertex; ++i) {
            corners[i] = PVector.add(center, this.largeVertices[i]);
        }

        return corners;
    }
}
