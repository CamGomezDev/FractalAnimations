ArrayList<Circle> circles = new ArrayList<Circle>();
float radius = 300;

void setup() {
    frameRate(30);
    size(1000, 1000);
    //fullScreen();
    circles.add(new Circle(
        new PVector(width/2, height/2),
        new PVector(width/2, height/2),
        radius, radius,
        0
    ));

    strokeWeight(2);

    // noFill();
    // noStroke();
}

void draw() {
    background(0);

    ArrayList<Circle> newCircles = new ArrayList<Circle>();

    for (Circle circle : circles) {
        boolean circleBefore = circle.creating;
        circle.render();
        if (circle.creating != circleBefore) {
            newCircles.addAll(circle.createChildrenCircles());
        }
    }

    circles.addAll(newCircles);
}
