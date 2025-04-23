% Parameters
int: N; % Number of different illuminations
int: M; % Number of lamp powers
array[1..N, 1..M] of float: Coefficients; % Coefficients relating lamp powers to illumination
array[1..N] of float: DesiredIlluminations; % Desired level of illuminations

% Variables
array[1..M] of var float: LampPowers; % Powers of each lamp

% Constraints

% The illumination of each segment is the sum of the product of the power of each lamp and its corresponding coefficient
constraint forall(i in 1..N)(
    let {
        var float: illumination = sum(j in 1..M)(Coefficients[i,j] * LampPowers[j])
    } in
    % The absolute error between the actual illumination and the desired illumination should be minimized
    abs(illumination - DesiredIlluminations[i]) <= 0.01
);

% Objective

% Minimize the absolute error between the actual illumination and the desired illumination
solve minimize sum(i in 1..N)(abs(sum(j in 1..M)(Coefficients[i,j] * LampPowers[j]) - DesiredIlluminations[i]));