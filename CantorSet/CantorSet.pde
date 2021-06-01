ArrayList<Line> lines = new ArrayList<Line>();
float length = 1000;

void setup() {
    size(1200, 1000);
    // fullScreen();
    lines.add(new Line(
        new PVector(100, 300), 
        length, 
        0
    ));
}

void draw() {
    background(0);

    ArrayList<Line> newLines = new ArrayList<Line>();

    for (Line line : lines) {
        boolean lineBefore = line.creating;
        line.render();
        if (line.creating != lineBefore) {
            newLines.addAll(line.getChildrenLines());
        }
    }

    lines.addAll(newLines);
}
