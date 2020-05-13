%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task
% Working Group on Modern Heuristic Optimization
% Intelligent Systems Subcommittee
% Power System Analysis, Computing, and Economic Committee
%
% 
% Sebastian Wildenhues (E-Mail: sebastian.wildenhues@uni-due.de)
% 24/04/2020
%
% This is a typical layout of an off-shore WPP. Parameters of system 
% components were taken from a off-shore WPP in Germany.
%
% See Matpower user's manual for details on the case file format.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mpc = system_13
%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data 
% bus_i	   type	    Pd	   Qd	    Gs	    Bs	   area	   Vm	   Va	   baseKV  zone	   Vmax	    Vmin
mpc.bus = [
	1       3       347.35  0       0       0       1       1       0        150     1       1.1424   0.8576;        
    2       1       0       0       0       0       1       1       0        150     1       1.1424   0.8576;
	3       1       0       0       0       0       1       1       0        150     1       1.1424   0.8576;
	4       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
	5       1       0       0       0       0       1       1       0        150     1       1.1424   0.8576;  
	6       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
    7       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
    8       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
    9       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
   10       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
   11       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
   12       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
   13       1       0       0       0    	0       1       1       0        33      1       1.1424   0.8576;
   14       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   15       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   16       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   17       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   18       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   19       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   20       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   21       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   22       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   23       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   24       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   25       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   26       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   27       1       0       0       0       0       1       1       0        33      1       1.1424   0.8576;
   28       1       0       0       0       -12     1       1       0        33      1       1.1424   0.8576;%shunt reactor
   ];
%% generator data
%% The Qmax and Qmin are set to 0 in order to test if the system convergs.
%% The generating strings as well as the strings are modeled in the generator data and bus data.
%  bus	Pg	    Qg	    Qmax	Qmin	Vg	   mBase  status   Pmax    Pmin	    Pc1	   Pc2	  Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc  ramp_10  ramp_30  ramp_q  apf
mpc.gen = [
	1	0         0       0        0        1.0     100     1      358.15   0       0       0       0       0       0       0       0       0       0       0       0;
    11	30.3      10.1    10.1     10.1     1.0     100     1      30.3     30.3    0       0       0       0       0       0       0       0       0       0       0;
    16	30.3      10.1    10.1     10.1     1.0     100     1      30.3     30.3    0       0       0       0       0       0       0       0       0       0       0;
    22	30.3      10.1    10.1     10.1     1.0     100     1      30.3     30.3    0       0       0       0       0       0       0       0       0       0       0;
    27	30.3      10.1    10.1     10.1     1.0     100     1      30.3     30.3    0       0       0       0       0       0       0       0       0       0       0;
    8	33        22.4    22.4     22.4     1.0     100     1      32       32      0       0       0       0       0       0       0       0       0       0       0;
    9	29.4      19.15   19.15    19.15	1.0     100     1      28.6     28.6    0       0       0       0       0       0       0       0       0       0       0;
    10	28.8      19.6    19.6     19.6     1.0     100     1      28       28      0       0       0       0       0       0       0       0       0       0       0;
    13	28.8      19.6    19.6     19.6     1.0     100     1      28       28      0       0       0       0       0       0       0       0       0       0       0;
    14	29.15     13.248  13.248   13.248   1.0     100     1      29.15    29.15   0       0       0       0       0       0       0       0       0       0       0;
    15	28        19.6    19.6     19.6     1.0     100     1      28       28      0       0       0       0       0       0       0       0       0       0       0;
    18	16        12.2    12.2     12.2     1.0     100     1      16       16      0       0       0       0       0       0       0       0       0       0       0;
    19	16.8      10.9    10.9     10.9     1.0     100     1      16.4     16.4    0       0       0       0       0       0       0       0       0       0       0;
    20	28        19.6    19.6     19.6     1.0     100     1      28       28      0       0       0       0       0       0       0       0       0       0       0;
    21	32        22.4    22.4     22.4     1.0     100     1      32       32      0       0       0       0       0       0       0       0       0       0       0;
    24	29.4      18.55   18.55    18.55    1.0     100     1      29.4     29.4    0       0       0       0       0       0       0       0       0       0       0;
    25	33.6      21.2    21.2     21.2     1.0     100     1      29.4     29.4    0       0       0       0       0       0       0       0       0       0       0;
    26	29.4      19.15   19.15    19.15    1.0     100     1      28.6     28.6    0       0       0       0       0       0       0       0       0       0       0;
   %Equivalent grid
];

%% branch data

%%the p.u calculations are checked several times; lecture and the data of
%%ABB are used in order to find the right p.u values for the transformer.

% fbus  tbus	   r	       x	      b	       rateA   rateB   rateC   ratio   angle  status	    ratiomax	ratiomin
mpc.branch = [
    %Main bus to transformer
    1   2       0.01089111111       0.03198             0.1378373777         428.4      428.4      428.4        0       0       1       0        0;
    2	3       0.000005379555556	0.00001526222222	0.0008796145272      428.4      428.4      428.4        0       0       1       0        0;
    2   5       0.000003615377778	0.00001025711111	0.0005911527043      428.4      428.4      428.4        0       0       1       0        0;
    3	4       0                   0.15                0.000692791866       138.458    138.458    138.458      1.0     0       1       1.153    0.867;
    5   6       0                   0.15                0.000692791866       138.458    138.458    138.458      1.0     0       1       1.153    0.867;
    %%T01 and T02 to strings                                                                                 
    4   7       0.0001698806244     0.0004820936639     0.0000650026936      90        90        90             0        0       1        0        0;                                                                                                                                  
    7   8       0.004994490358      0.01417355372       0.001911079192       22.68     22.68     22.68          0        0       1        0        0;
    7   9       0.01016905418       0.02885812672       0.003891061239       22.68     22.68     22.68          0        0       1        0        0;
    7   10      0.006064738292      0.0172107438        0.002320596162       22.68     22.68     22.68          0        0       1        0        0;           
    7   11      0.009632231405      0.02733471074       0.003685652727       22.68     22.68     22.68          0        0       1        0        0;
    7   12      0.0000451882461     0.0001282369146     0.0000172907165      22.68     22.68     22.68          0        0       0        0        0;
    6   12      0.0003397612489     0.0009641873278     0.0001300053872      90        90        90             0        0       1        0        0;
    12  13      0.01087915519       0.03087327824       0.004162772498       22.68     22.68     22.68          0        0       1        0        0;
    12  14      0.02661349862       0.07552479339       0.01018332198        22.68     22.68     22.68          0        0       1        0        0;
    12  15      0.01594839302       0.04525895317       0.006102452876       22.68     22.68     22.68          0        0       1        0        0;
    12  16      0.01258135904       0.03570385675       0.004814099488       22.68     22.68     22.68          0        0       1        0        0;
    12  17      0.0002028374656     0.0005756198347     0.00007761321616     22.68     22.68     22.68          0        0       1        0        0;
    6   17      0.0001868686869     0.0005303030303     0.00007150296296     90        90        90             0        0       1        0        0;
    17  18      0.02247520661       0.06378099174       0.008599856364       22.68     22.68     22.68          0        0       1        0        0;   
    17  19      0.01801753903       0.05113085399       0.006894185684       22.68     22.68     22.68          0        0       1        0        0;
    17  20      0.01170137741       0.03320661157       0.004477385535       22.68     22.68     22.68          0        0       1        0        0;
    17  21      0.01373654729       0.03898209366       0.005256117805       22.68     22.68     22.68          0        0       1        0        0;
    17  22      0.01767777778       0.05016666667       0.006764180296       22.68     22.68     22.68          0        0       1        0        0;
    17  23      0.0000451882461     0.0001282369146     0.0000172907165      22.68     22.68     22.68          0        0       0        0        0;       
    4   23      0.0001698806244     0.0004820936639     0.0000650026936      90        90        90             0        0       1        0        0;
    23  24      0.02568595041       0.07289256198       0.009828407273       22.68     22.68     22.68          0        0       1        0        0;
    23  25      0.02365417815       0.06712672176       0.009050975057       22.68     22.68     22.68          0        0       1        0        0;  
    23  26      0.01070247934       0.03037190083       0.004095169697       22.68     22.68     22.68          0        0       1        0        0;   
    23  27      0.006499632691      0.01844490358       0.002487003057       22.68     22.68     22.68          0        0       1        0        0;
    12  28      0.0002010367309     0.0005705096419     0.00007692418761     22.68     22.68     22.68          0        0       1        0        0;     
    17  28      0.0002010367309     0.0005705096419     0.00007692418761     22.68     22.68     22.68          0        0       1        0        0; 
 ];
