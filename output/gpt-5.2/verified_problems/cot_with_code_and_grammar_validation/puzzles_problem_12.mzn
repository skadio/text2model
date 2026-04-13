% Parameters
int: area1;
int: area2;
int: area3;

% Variables
var 1..(area1 + area3): x;                 % left width
var 1..(area2 + area3): len;               % right width
var 1..(area1 + area2): y;                 % top height
var 1..(area3 + area2): height;            % bottom height
var 1..(area1 + area2 + area3): area4;     % unknown area

% Constraints
constraint x * y = area1;
constraint len * y = area2;
constraint x * height = area3;
constraint len * height = area4;

% Objective
solve satisfy;