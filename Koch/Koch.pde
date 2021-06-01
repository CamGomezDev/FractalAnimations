ArrayList<KochLine> kochLines = new ArrayList<KochLine>();
boolean linesFinishedCreating;

float camRotation = 0;
float camRotationChange = 0.0;
PVector camCenter;

void setup() {
    frameRate(30);
    size(1400, 1000);
    // fullScreen();
    
    // Here you can comment and uncomment all the shapes that you want
    // showing up.
    
    // The large number in the arguments represents the size of the shape 
    kochPentagon(500, 3);
    kochStar(5, 0.1, 400, 4, 2);
    kochStar(5, 0.5, 900, 3, 5);
    kochPentagon(1000, 1);
    kochPentagon(30, 2);
    kochStar(5, 0.5, 1400, 0, 1);
    // kochLine();
    // kochSnowFlake();
    // kochSquare();

    camCenter = new PVector(width/2, height/2);
}

void draw() {
    background(0);

    linesFinishedCreating = true;

    camRotation += camRotationChange;
    if (camRotation >= 2*PI) {
        camRotation = 0;
    }
    rotate(camRotation);
    float camCenterAngle = atan(camCenter.y/camCenter.x);
    float theta = PI/2 + camRotation/2 - camCenterAngle;
    float h = camCenter.mag() * sqrt(2 * (1 - cos(camRotation)));
    float deltaX = h * cos(theta);
    float deltaY = h * sin(theta);
    translate(deltaX, -deltaY);


    for (KochLine kochLine : kochLines) {
        kochLine.render();
        if (kochLine.creating) {
            linesFinishedCreating = false;
        }
    }

    if (linesFinishedCreating) {
        ArrayList<KochLine> newKochLines = new ArrayList<KochLine>();
        for (KochLine kochLine : kochLines) {
            newKochLines.addAll(kochLine.createChildrenKochLines());
        }
        kochLines = newKochLines;
    }
}

void kochLine() {
    kochLines.add(new KochLine(
        new PVector(200, 800), 
        new PVector(1900, 800),
        0,
        false
    ));
    strokeWeight(5);
}

void kochSnowFlake() {
    float length = 900;
    PVector snowFlakeCenter = new PVector(width/2, height/2+100);
    PVector firstPoint = PVector.add(snowFlakeCenter, new PVector(-length/2, -length*tan(PI/3)/4));
    PVector secondPoint = PVector.add(snowFlakeCenter, new PVector(length/2, -length*tan(PI/3)/4));
    PVector thirdPoint = PVector.add(snowFlakeCenter, new PVector(0, length*tan(PI/3)/4));
    kochLines.add(new KochLine(
        firstPoint, 
        secondPoint,
        0, true
    ));
    kochLines.add(new KochLine(
        secondPoint,
        thirdPoint,
        0, true
    ));
    kochLines.add(new KochLine(
        thirdPoint,
        firstPoint,
        0, true
    ));
    strokeWeight(5);
}

void kochSquare() {
    float length = 600;
    PVector center = new PVector(1050, 600);
    PVector firstPoint = PVector.add(center, new PVector(-length/2, -length/2));
    PVector secondPoint = PVector.add(center, new PVector(length/2, -length/2));
    PVector thirdPoint = PVector.add(center, new PVector(length/2, length/2));
    PVector fourthPoint = PVector.add(center, new PVector(-length/2, length/2));
    kochLines.add(new KochLine(
        firstPoint,
        secondPoint,
        3, false
    ));
    kochLines.add(new KochLine(
        secondPoint,
        thirdPoint,
        3, false
    ));
    kochLines.add(new KochLine(
        thirdPoint,
        fourthPoint,
        3, false
    ));
    kochLines.add(new KochLine(
        fourthPoint,
        firstPoint,
        3, false
    ));
    strokeWeight(4);
}

void kochPentagon(float radius, int colIndex) {
    PVector center = new PVector(width/2, height/2);
    PVector firstPoint = PVector.add(center, new PVector(0, -radius));
    PVector secondPoint = PVector.add(center, new PVector(radius*cos(radians(18)), -radius*sin(radians(18))));
    PVector thirdPoint = PVector.add(center, new PVector(radius*cos(radians(-54)), -radius*sin(radians(-54))));
    PVector fourthPoint = PVector.add(center, new PVector(-radius*cos(radians(-54)), -radius*sin(radians(-54))));
    PVector fifthPoint = PVector.add(center, new PVector(-radius*cos(radians(18)), -radius*sin(radians(18))));
    kochLines.add(new KochLine(
        firstPoint,
        secondPoint,
        colIndex, true
    ));
    kochLines.add(new KochLine(
        secondPoint,
        thirdPoint,
        colIndex, true
    ));
    kochLines.add(new KochLine(
        thirdPoint,
        fourthPoint,
        colIndex, true
    ));
    kochLines.add(new KochLine(
        fourthPoint,
        fifthPoint,
        colIndex, true
    ));
    kochLines.add(new KochLine(
        fifthPoint,
        firstPoint,
        colIndex, true
    ));
    strokeWeight(3);
}

void kochStar(int numVertex, float thickness, float radius, int colOne, int colTwo) {
    PVector center = new PVector(width/2, height/2);
    float sectionAngle = 2 * PI / numVertex;
    PVector[] largeVertices = new PVector[numVertex];
    PVector[] smallVertices = new PVector[numVertex];
    for (int i = 0; i < numVertex; i++) {
        largeVertices[i] = PVector.add(center, new PVector(
            sin(sectionAngle*(i-1) + sectionAngle), 
            cos(sectionAngle*(i-1) + sectionAngle)
        ).mult(radius));
        smallVertices[i] = PVector.add(center, new PVector(
            sin(sectionAngle*i + sectionAngle/2), 
            cos(sectionAngle*i + sectionAngle/2)
        ).mult(thickness*radius));
    }

    for (int i = 0; i < numVertex; i++) {
        kochLines.add(new KochLine(smallVertices[i], largeVertices[i], colOne, true));
        if (i != numVertex - 1) {
            kochLines.add(new KochLine(largeVertices[i+1], smallVertices[i], colTwo, true));
        } else {
            kochLines.add(new KochLine(largeVertices[0], smallVertices[i], colTwo, true));
        }
    }

    strokeWeight(4);
}
