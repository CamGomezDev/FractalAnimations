float largestLength = 350;
int numVertex = 6;
float thickness = 0.1;
float reductionFactor = 0.6;

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Star> newStars;

void setup() {
    size(1000, 1000);
    stars.add(new Star(new PVector(width/2, height/2), largestLength, numVertex, thickness));
}

void draw() {
    background(color(255, 255, 255));

    newStars = new ArrayList<Star>();
        
    for (Star star : stars) {
        boolean starBefore = star.creating;
        star.render();
        if (star.creating != starBefore) {
            PVector[] starCorners = star.getCorners();
            for (int i = 0; i < starCorners.length; ++i) {
                newStars.add(new Star(
                    starCorners[i], star.length*reductionFactor,
                    numVertex, thickness
                ));
            }
        }
    }

    stars.addAll(newStars);
}
