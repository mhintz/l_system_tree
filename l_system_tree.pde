/* modular L-System sketch */
// L-System implementation based on http://www.openprocessing.org/sketch/103747

// set L-System choice here
SystemRules ruleset = new AlderRules();

color bgColor = color(255);
color plantColor = color(30, 75, 0);

void setup() {
	size(800, 800);

	createNewTree();
}

void draw() {}

void mouseClicked() {
	createNewTree();
}

void createNewTree() {
	String treeRules = generateBoughs(ruleset.numBranches, ruleset.root);  // create rules for turtle graphics
	drawBoughs(ruleset.unitLength, ruleset.unitAngle, treeRules); // draw turtle graphics
}

class SystemRules {
	int numBranches;
	float unitLength;
	float unitAngle;
	String root;
	String generate(char input) { return "" + input; }
}

class AlderRules extends SystemRules {
	AlderRules() {
		numBranches = 7;
		unitLength = 1.5;
		unitAngle = radians(30);
		root = "X";
	}

	String generate(char input) {
		switch (input) {
			case 'X':
				return "F-[[X]+X]+F[+FX]-X";
			case 'F':
				return random(1) < 0.1 ? "FFF" : "FF";
			default:
				return "" + input;
		}
	}
}

class BourkeBushRules extends SystemRules {
	BourkeBushRules() {
		numBranches = 10;
		unitLength = 10;
		unitAngle = radians(20);
		root = "VZFFF";
	}

	String generate(char input) {
		switch (input) {
			case 'V':
				return "[+++W][---W]YV";
			case 'W':
				return "+X[-W]Z";
			case 'X':
				return "-W[+X]Z";
			case 'Y':
				return "YZ";
			case 'Z':
				return "[-FFF][+FFF]F";
			default:
				return "" + input;
		}
	}
}


String generateBoughs(int recurLevel, String input) {  // prepare rules for the turtle graphics
	// http://en.wikipedia.org/wiki/L-system
	// variables : X F
	// constants : + - [ ]
	// start  : X
	// rules  : (X -> F-[[X]+X]+F[+FX]-X), (F -> FF)
	// interprets the rules derived from the nature

	String resultStr = "";
	// check if recursion level counter has reached 0
	if (recurLevel > 0) {
		char[] characters = input.toCharArray();
		for (char symbol : characters) {
			resultStr += generateBoughs(recurLevel - 1, ruleset.generate(symbol));
		}
	} else {
		resultStr = input;
	}
	return resultStr;
}
	
void drawBoughs(float length, float angle,  String sentence) {  // draw turtle graphics
	// http://en.wikipedia.org/wiki/L-system
	// Here, F means "draw forward", - means "turn left", and + means "turn right".
	// X does not correspond to any drawing action, but is used to control the evolution of the curve.
	// [ corresponds to saving the current values for position and angle, which are restored when
	// the corresponding ] is executed.

	background(bgColor);

	strokeWeight(1);
	stroke(plantColor);

	translate(width / 2, height); // plant the tree at bottom center

	char[] characters = sentence.toCharArray();
	for (char c : characters) {
		switch (c) {  //interprets the rules derived from the nature
			case '-':
				rotate(-angle);
				break;
			case '+':
				rotate(angle);
				break;
			case '[':
				pushMatrix();
				break;
			case ']':
				popMatrix();
				break;
			case 'F':
				line(0, 0, 0, -length); // from draw origin, draw a branch upwards
				translate(0, -length); // move the origin to the branch end
				break;
		}
	}
}