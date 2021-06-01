float largestLength = 300;
int numVertex = 4;
float thickness = 0.2;
float reductionFactor = 0.5;

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Star> newStars;

PVector camCenter;
PVector camSpeed = new PVector(-0.75, -0.21);
float camScale = 1;
float camRotation = radians(0);
float camScaleChange = 0.015;
float camRotationChange = 0.01;

void setup() {
    size(1000, 1000);
    // fullScreen();
    stars.add(new Star(new PVector(width/2, height/2), largestLength, numVertex, thickness, 0, 2, 0.5, 30.5));
    camCenter = new PVector(width/2, height/2);
    frameRate(30);
}

void draw() {
    background(0);

    camScale += camScaleChange;
    camCenter.add(camSpeed);
    // translate(camCenter.x, camCenter.y);


    scale(camScale);
    translate(-(camCenter.x - width/(2*camScale)), -(camCenter.y - height/(2*camScale)));
    
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
    // translate(-camCenter.x, -camCenter.y);

    // circle(camCenter.x, camCenter.y, 30);

    newStars = new ArrayList<Star>();    
    for (Star star : stars) {
        boolean starBefore = star.creating;
        star.render();
        if (star.creating != starBefore) {
            newStars.addAll(star.getChildrenStars());
        }
    }
    stars.addAll(newStars);
}
