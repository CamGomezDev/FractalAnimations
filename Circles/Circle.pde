public class Circle {
    boolean creating = true;
    PVector center;
    float radius;
    float sizeFactor = 0;
    float changeSpeed = 0.012;
    float redFactor = 0.48;
    PVector shift;
    float radiusShift;

    PVector firstCenter;
    float firstRadius;

    color colFill;
    color colStroke;
    int nextColorIndex;
    color[] colorsFill = {
        color(255, 53, 53, 120),  // Red
        color(63, 255, 53, 120),   // Green
        color(53, 53, 255, 120),  // Blue
        color(255, 255, 53, 120),    // Yelllow
        // color(244, 53, 255, 120),    // Purple
        // color(255, 127, 22, 120)   // Orange
    };

    color[] colorsStroke = {
        color(255, 53, 53),  // Red
        color(63, 255, 53),   // Green
        color(53, 53, 255),  // Blue
        color(255, 255, 53),    // Yelllow
        // color(244, 53, 255),    // Purple
        // color(255, 127, 22)   // Orange
    };

    Circle(PVector firstCenter, PVector center, float firstRadius, float radius, int colorIndex) {
        this.firstCenter = firstCenter;
        this.firstRadius = firstRadius;

        this.center = center;
        this.radius = radius;

        this.shift = PVector.sub(center, firstCenter);
        this.radiusShift = firstRadius - radius;

        this.colFill = colorsFill[colorIndex];
        this.colStroke = colorsStroke[colorIndex];
        if (colorIndex + 1 == this.colorsFill.length) {
            this.nextColorIndex = 0;
        } else {
            this.nextColorIndex = colorIndex+1;
        }
    }

    void render() {
        stroke(this.colStroke);
        fill(this.colFill);

        if (creating) {
            sizeFactor += changeSpeed;
            if (sizeFactor >= 1) {
                sizeFactor = 1;
                creating = false;
            }
            PVector newCenter = PVector.add(firstCenter, PVector.mult(shift, sizeFactor));
            float newRadius = firstRadius - sizeFactor*radiusShift;
            circle(newCenter.x, newCenter.y, 2*newRadius);
        } else {
            PVector newCenter = PVector.add(firstCenter, PVector.mult(shift, sizeFactor));
            circle(center.x, center.y, 2*radius);
        }
        
    }

    ArrayList<Circle> createChildrenCircles() {
        ArrayList<Circle> childrenCircles = new ArrayList<Circle>();

        PVector topCorner = new PVector(0, -radius);
        PVector rightCorner = new PVector(radius, 0);
        PVector bottomCorner = new PVector(0, radius);
        PVector leftCorner = new PVector(-radius, 0);

        childrenCircles.add(new Circle(center, PVector.add(center, topCorner), radius, radius*redFactor, nextColorIndex));
        childrenCircles.add(new Circle(center, PVector.add(center, rightCorner), radius, radius*redFactor, nextColorIndex));
        childrenCircles.add(new Circle(center, PVector.add(center, bottomCorner), radius, radius*redFactor, nextColorIndex));
        childrenCircles.add(new Circle(center, PVector.add(center, leftCorner), radius, radius*redFactor, nextColorIndex));

        return childrenCircles;
    }
}
