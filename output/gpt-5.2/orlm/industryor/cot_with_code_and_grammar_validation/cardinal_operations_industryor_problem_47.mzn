% Parameters
int: t1A = 4;
int: t1B = 6;
int: cap1 = 150;

int: t2A = 3;
int: t2B = 2;
int: cap2 = 70;

int: profitA = 300;
int: profitB = 450;

int: minProfit = 10000;
int: minA = 10;
int: minB = 15;

int: otMax2 = 30;
int: otPenaltyA = 20;
int: otPenaltyB = 25;

% Safe upper bounds for production (from capacities + overtime)
int: maxX_A = (cap1 div t1A);                 % Process I limits A alone
int: maxX_B = (cap1 div t1B);                 % Process I limits B alone
int: UB = max(maxX_A, maxX_B);                % generic safe bound

% Variables
var 0..UB: xA;                 % total units of A
var 0..UB: xB;                 % total units of B

var 0..UB: xA_ot2;             % units of A done in overtime for Process II
var 0..UB: xB_ot2;             % units of B done in overtime for Process II

var 0..otMax2: ot2;            % overtime hours used in Process II

var int: total_profit;

% Constraints
constraint xA >= minA;
constraint xB >= minB;

% Process I must be exactly fully utilized
constraint t1A * xA + t1B * xB = cap1;

% Process II can use regular + overtime (bounded)
constraint t2A * xA + t2B * xB <= cap2 + ot2;

% Overtime hours must cover the portion assigned to overtime units
constraint t2A * xA_ot2 + t2B * xB_ot2 = ot2;

% Overtime units cannot exceed total produced
constraint xA_ot2 <= xA;
constraint xB_ot2 <= xB;

% Overtime units must be consistent with needing overtime
% (If total Process II hours fit within regular capacity, overtime can be 0.)
constraint t2A * xA + t2B * xB - cap2 <= ot2;

% Profit definition with overtime penalty per overtime-produced unit
constraint total_profit =
    profitA * xA + profitB * xB
  - otPenaltyA * xA_ot2 - otPenaltyB * xB_ot2;

% Minimum profit requirement
constraint total_profit >= minProfit;

% Objective
solve maximize total_profit;