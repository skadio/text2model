% Parameters
int: cost1 = 300;
int: cost2 = 600;

int: black1 = 5;
int: white1 = 6;
int: brown1 = 3;

int: black2 = 10;
int: white2 = 10;
int: brown2 = 0;

int: req_black = 20;
int: req_white = 5;
int: req_brown = 15;

% Upper bounds for hours (safe bounds based on meeting requirements with worst-case single factory)
int: ub1 = max(ceil(req_black div black1 + (if req_black mod black1 > 0 then 1 else 0 endif)),
              max(ceil(req_white div white1 + (if req_white mod white1 > 0 then 1 else 0 endif)),
                  ceil(req_brown div brown1 + (if req_brown mod brown1 > 0 then 1 else 0 endif))));
int: ub2 = max(ceil(req_black div black2 + (if req_black mod black2 > 0 then 1 else 0 endif)),
              ceil(req_white div white2 + (if req_white mod white2 > 0 then 1 else 0 endif)));

% Variables
var 0..ub1: h1;  % hours to run factory 1
var 0..ub2: h2;  % hours to run factory 2

var 0..(black1*ub1 + black2*ub2): black_total;
var 0..(white1*ub1 + white2*ub2): white_total;
var 0..(brown1*ub1 + brown2*ub2): brown_total;

var 0..(cost1*ub1 + cost2*ub2): total_cost;

% Constraints
constraint black_total = black1*h1 + black2*h2;
constraint white_total = white1*h1 + white2*h2;
constraint brown_total = brown1*h1 + brown2*h2;

constraint black_total >= req_black;
constraint white_total >= req_white;
constraint brown_total >= req_brown;

constraint total_cost = cost1*h1 + cost2*h2;

% Objective
solve minimize total_cost;