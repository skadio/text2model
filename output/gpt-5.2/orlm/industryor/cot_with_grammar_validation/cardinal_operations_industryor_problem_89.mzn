% Parameters
int: shirts = 200;
int: pants = 100;

int: priceA = 30;
int: priceB = 50;

int: shirtA = 1;
int: pantsA = 2;

int: shirtB = 3;
int: pantsB = 1;

int: minA = 20;
int: minB = 10;

% Variables
var minA..shirts: A;
var minB..shirts: B;

% Constraints
constraint shirtA * A + shirtB * B <= shirts;
constraint pantsA * A + pantsB * B <= pants;

% Objective
solve maximize priceA * A + priceB * B;