% Parameters
int: shirts = 200;
int: pants = 100;

int: priceA = 30;
int: priceB = 50;

int: shirtsA = 1;
int: pantsA = 2;

int: shirtsB = 3;
int: pantsB = 1;

int: minA = 20;
int: minB = 10;

% Variables
var minA..shirts: A;
var minB..shirts: B;
var 0..(priceA*shirts + priceB*shirts): revenue;

% Constraints
constraint shirtsA*A + shirtsB*B <= shirts;
constraint pantsA*A + pantsB*B <= pants;

constraint revenue = priceA*A + priceB*B;

% Objective
solve maximize revenue;