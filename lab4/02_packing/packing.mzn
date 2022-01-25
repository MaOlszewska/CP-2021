include "globals.mzn";
% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares
% Variables
%%%%%%%%%%%
int: sum = sum(SQUARES);
int: sumSqr = sum([i*i | i in SQUARES]);
var n..sum: height;    % height of the container
var n..sum: width;     % width of the conainer
var sumSqr..(sum*n): area = height * width; % container's area
array[SQUARES] of var 0..(sum-1): x; % squares' coordinates in the container
array[SQUARES] of var 0..(sum-1): y; % squares' coordinated in the container
  
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Constraint 1: Squares should fit inside the container
constraint forall([ x[i] + i <= width /\ y[i] + i <= height | i in SQUARES]);
% Constraint 2: Squares should not overlap
% constraint forall(i,j in SQUARES where i != j)(x[i] + i <= x[j] \/ y[i] + i <= y[j] \/ x[j] + j <= x[i] \/ y[j] + j <= y[i]);
constraint diffn(x, y, 0..n-1, 0..n-1);
% Redundant
constraint cumulative(x, SQUARES, SQUARES, height);
constraint cumulative(y, SQUARES, SQUARES, width);
% Symmetry
constraint height < width;
% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve :: seq_search ([
  int_search([width, height], dom_w_deg, indomain_min),
  int_search(reverse(x), input_order, indomain_min),
  int_search(reverse(y), input_order, indomain_min)
]) minimize area; 
  
% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)];