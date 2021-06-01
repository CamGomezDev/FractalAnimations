float largestLength = 400;
int numVertex = 6;
float thickness = 0.2;
float reductionFactor = 0.5;

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Star> newStars;

void setup() {
    size(1000, 1000);
    stars.add(new Star(new PVector(width/2, height/2), largestLength, numVertex, thickness, 0));
    frameRate(30);
}

void draw() {
    background(0);

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
