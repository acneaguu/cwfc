%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task
% Working Group on Modern Heuristic Optimization
% Intelligent Systems Subcommittee
% Power System Analysis, Computing, and Economic Committee
%
% Dr.-Ing.  (E-Mail: f.g.n.rimon@student.tudelft.nl)
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
mpc.baseMVA = 120;

%% bus data 
% bus_i	   type	    Pd	   Qd	    Gs	    Bs	   area	   Vm	   Va	   baseKV  zone	   Vmax	    Vmin
mpc.bus = [
	1       3       0       0       0       0       1       1       0        150     1       1.09   0.85;        
    2       1       0       0       0       0       1       1       0        150     1       1.09 	0.85;
	3       1       0       0       0       0       1       1       0        150     1       1.09	0.85;
	4       1       0       0       0       0       1       1       0        33      1       1.09 	0.85;
	5       1       0       0       0       0       1       1       0        150     1       1.09	0.85;  
	6       1       0       0       0       0       1       1       0        33      1       1.09   0.85;
    7       1       0       0       0    	0       1       1       0        33      1       1.09	0.85;
    8       1       -33     0       0    	0       1       1       0        33      1       1.09	0.85;
    9       1       -29.4   0       0    	0       1       1       0        33      1       1.09	0.85;
   10       1       -29.4   0       0    	0       1       1       0        33      1       1.09	0.85;
   12       1       0       0       0    	0       1       1       0        33      1       1.09	0.85;
   13       1       -29.4   0       0    	0       1       1       0        33      1       1.09	0.85;
   14       1       -29.4   0       0       0       1       1       0        33      1       1.09	0.85;
   15       1       -29.4   0       0       0       1       1       0        33      1       1.09	0.85;
   16       1       0       0       0       0       1       1       0        33      1       1.09	0.85;
   17       1       -16     0       0       0       1       1       0        33      1       1.09	0.85;
   18       1       -16.8   0       0       0       1       1       0        33      1       1.09	0.85;
   19       1       -28     0       0       0       1       1       0        33      1       1.09	0.85;
   20       1       -32     0       0       0       1       1       0        33      1       1.09	0.85;
   21       1       0       0       0       -12     1       1       0        33      1       1.09	0.85;
   22       1       -29.4   0       0       0       1       1       0        33      1       1.09	0.85;
   23       1       -29.15  0       0       0       1       1       0        33      1       1.09	0.85;
   24       1       -28     0       0       0       1       1       0        33      1       1.09	0.85;
   26       1       0       0       0       0       1       1       0        33      1       1.09	0.85;
   27       1       0       0       0       0       1       1       0        33      1       1.09	0.85;
   28       1       -30.296 0       0       0       1       1       0        33      1       1.09   0.85;
   29       1       -30.296 0       0       0       1       1       0        33      1       1.09   0.85;
   30       1       -30.296 0       0       0       1       1       0        33      1       1.09   0.85;
   31       1       -30.296 0       0       0       1       1       0        33      1       1.09   0.85;
   ];
%% generator data
%  bus	Pg	    Qg	    Qmax	Qmin	Vg	   mBase  status   Pmax    Pmin	    Pc1	   Pc2	  Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc  ramp_10  ramp_30  ramp_q  apf
mpc.gen = [
	1	-347.41   0    125.35  -143.26	1.0     240     1      358.15   0       0       0       0       0       0       0       0       0       0       0       0; %Equivalent grid
];

%% branch data
% fbus  tbus	   r	       x	      b	       rateA   rateB   rateC   ratio   angle  status	    ratiomax	ratiomin
mpc.branch = [
    %Main bus to transformer
    1   2       8.25e-4         0         1.04e-6    265.65  265.65  265.65     0       0       1       0        0;
    2	3       1.51e-5         0         0          431.25  431.25  431.25     0       0       1       0        0;
    2   5       1.01e-5         0         0          431.25  431.25  431.25     0       0       1       0        0;
    3	4       0               0         0          431.25  431.25  431.25    4.5      0       1       5.19    3.90;
    5   6       0               0         0          431.25  431.25  431.25    4.5      0       1       5.19    3.90;
    %%T01 to strings                                                                                 
    4   7       5.1e-5        1.45e-4     4.19e-7          90       90      90       0        0       1        0        0;                                                               ;
    4   12      5.1e-5        1.45e-4     4.19e-7          90       90      90       0        0       1        0        0;                                                                       ;
    7   8       5.99e-3       0.017       2.79e-5          22.68   22.68   22.68     0        0       1        0        0;
    7   9       0.0122        0.0346      5.69e-5          22.68   22.68   22.68     0        0       1        0        0;
    7   28      8.0e-3        0.022       8.01e-8          22.68   22.68   22.68     0        0       1        0        0;           
    7   10      7.28e-3       0.021       3.39e-5          22.68   22.68   22.68     0        0       1        0        0;
    12  13      0.0308        0.087       1.44e-4          22.68   22.68   22.68     0        0       1        0        0;
    12  14      0.028         0.081       1.32e-4          22.68   22.68   22.68     0        0       1        0        0;
    12  15      0.0128        0.036       5.99e-5          22.68   22.68   22.68     0        0       1        0        0;
    12  29      0.0116        0.0328      1.19e-7          22.68   22.68   22.68     0        0       1        0        0;
    6   16      5.61e-5       1.59e-3     4.61e-6          90     90       90        0        0       1        0        0;
    6   21      1.02e-4       2.89e-4     7.60e-6          90     90       90        0    	  0       1        0        0;
    16  17      0.027         0.077       1.26e-4          22.68  22.68    22.68     0        0       1        0        0;
    16  18      0.022         0.061       1.01e-4          22.68  22.68    22.68     0   	  0       1        0        0;
    16  19      0.014         0.04        6.54e-5          22.68  22.68    22.68     0    	  0       1        0        0;
    16  20      0.016         0.047       7.68e-5          22.68  22.68    22.68     0        0       1        0        0;   
    16  30      0.015         0.043       1.55e-5          22.68  22.68    22.68     0        0       1        0        0;
    21  22      0.013         0.037       6.08e-5          22.68  22.68    22.68     0        0       1        0        0;
    21  23      0.032         0.091       1.49e-4          22.68  22.68    22.68     0        0       1        0        0;
    21  24      0.019         0.057       8.92e-5          22.68  22.68    22.68     0        0       1        0        0;
    21  31      0.021         0.0602      2.18e-7          22.68  22.68    22.68     0        0       1        0        0;       
    %T01, T02 to shunt reactor
    7   21      0             0                0             90    90    90         0        0       0       0          0;
    12  16      0             0                0             90    90    90         0        0       0       0          0;
    %transformers to feed T05 and T06
    12  26      0             0                0             0.25  0.25  0.25       0       0       0       0          0;
    21  27      0             0                0             0.25  0.25  0.25       0       0       0       0          0;
 ];

%% Day profile of active power dispatch for individual wind turbines
mpc.WPP_dispatch = [ %%each row is the dispatch of a certain wind farm
    2.8326	2.8253	2.8302	2.7878	2.8567	2.835	2.8143	2.7906	2.8283	2.8244	2.8278	2.7929	2.8147	
    2.7711	2.7735	2.7729	2.7598	2.7713	2.779	2.7398	2.7693	2.7772	2.7398	2.7948	2.7359	2.8077
    2.1776	2.1674	2.1645	2.1908	2.1462	2.1771	2.1415	2.1984	2.1612	2.206	2.1761	2.1487	2.1719	
    2.6385	2.612	2.6507	2.6148	2.6352	2.6688	2.6699	2.6434	2.6443	2.6305	2.6204	2.5999	2.6619
    2.7753	2.8125	2.7526	2.7548	2.7684	2.745	2.7409	2.7581	2.8028	2.8204	2.7995	2.7985	2.7758	
    3.406	3.4466	3.3756	3.3661	3.4422	3.3621	3.4296	3.4414	3.3976	3.45	3.4458	3.4571	3.4504	
    3.0896	3.1133	3.0715	3.0519	3.1156	3.1038	3.1317	3.1215	3.0864	3.0817	3.0611	3.0925	3.0651	
    3.2262	3.1841	3.2152	3.2433	3.2208	3.2448	3.1873	3.2147	3.2053	3.2061	3.2054	3.1804	3.2362	
    3.8227	3.7968	3.835	3.8046	3.8219	3.8762	3.8303	3.8236	3.8692	3.8649	3.7743	3.7975	3.7893	
    4.1	4.0717	4.1406	4.1297	4.1443	4.1101	4.1004	4.1282	4.1472	4.124	4.0514	4.0438	4.082
    2.9397	2.9302	2.8998	2.9671	2.9122	2.9021	2.9638	2.9473	2.9642	2.9236	2.894	2.9031	2.9537
    3.3947	3.3561	3.406	3.395	3.4025	3.4433	3.4094	3.3501	3.4047	3.3475	3.425	3.3994	3.4459	
    3.524	3.5557	3.5315	3.4887	3.5624	3.5521	3.5646	3.4998	3.5443	3.5498	3.4924	3.5135	3.5487	
    4.2228	4.2214	4.1804	4.2009	4.2481	4.2205	4.2075	4.2702	4.1836	4.2502	4.2709	4.2815	4.2463	
    5	5	5	5	5	5	5	5	5	5	5	5   5	
    4.9038	4.8837	4.8813	4.9501	4.8803	4.8534	4.9353	4.8957	4.9641	4.9597	4.9448	4.9089	4.95	
    4.8678	4.8203	4.9128	4.9299	4.8332	4.8686	4.9303	4.8636	4.9024	4.861	4.9163	4.8279	4.8313	
    5	5	5	5	5	5	5	5	5	5	5	5   5	
    5	5	5	5	5	5	5	5	5	5	5	5	5
    5	5	5	5	5	5	5	5	5	5	5	5	5
    5	5	5	5	5	5	5	5	5	5	5	5	5
    5	5	5	5	5	5	5	5	5	5	5	5	5
    5	5	5	5	5	5	5	5	5	5	5	5	5
    5	5	5	5	5	5	5	5	5	5	5	5	5
    4.5743	4.5963	4.5287	4.6036	4.5478	4.629	4.5421	4.6188	4.5151	4.5419	4.5577	4.5232	4.5309	
    4.4735	4.4341	4.5191	4.4942	4.4351	4.418	4.4911	4.477	4.4453	4.5185	4.5098	4.4152	4.5199
    4.5725	4.5502	4.5225	4.602	4.5847	4.621	4.6256	4.57	4.5731	4.5834	4.5261	4.5464	4.601
    5	5	5	5	5	5	5	5	5	5	5	5	5	
    4.7692	4.7447	4.7513	4.754	4.7119	4.8198	4.7112	4.7195	4.7329	4.7509	4.7408	4.7691	4.7763	
    4.8695	4.9146	4.8709	4.8422	4.8258	4.8523	4.9093	4.8786	4.8244	4.9081	4.8592	4.8499	4.8427
    3.6954	3.6454	3.6501	3.6586	3.6626	3.7256	3.6435	3.6474	3.6657	3.7278	3.7249	3.6907	3.7368	
    3.289	3.2405	3.302	3.3058	3.2626	3.2801	3.2806	3.3212	3.2528	3.2921	3.3279	3.2982	3.2943
    3.4593	3.4629	3.4454	3.4459	3.504	3.432	3.5095	3.4851	3.4811	3.4479	3.5036	3.4286	3.4895
    3.6088	3.6246	3.6014	3.6336	3.6256	3.5857	3.6373	3.5617	3.5958	3.6337	3.5609	3.6235	3.6151
    2.9285	2.9276	2.9062	2.8934	2.9284	2.9627	2.9524	2.9369	2.9613	2.9465	2.9332	2.8848	2.9009
    3.0014	2.9638	3.0445	3.0341	2.9951	3.0412	3.015	3.0093	3.0202	3.0438	2.9992	2.9865	3.0203
    2.0754	2.0526	2.0876	2.0548	2.0665	2.0526	2.097	2.1124	2.1055	2.0734	2.0975	2.0736	2.0932
    1.343	1.3672	1.3606	1.3471	1.3312	1.3492	1.3698	1.3244	1.342	1.3353	1.3575	1.3279	1.3559
    1.3267	1.3341	1.3251	1.3139	1.3178	1.3301	1.3108	1.318	1.3055	1.3317	1.3132	1.3197	1.3505	
    1.6357	1.6495	1.66	1.6545	1.659	1.6077	1.6554	1.6135	1.6487	1.6534	1.6207	1.6471	1.6395
    1.9264	1.9166	1.9252	1.9363	1.9275	1.9074	1.9553	1.9023	1.9559	1.8928	1.8905	1.9507	1.9603
    2.5037	2.488	2.509	2.51	2.4976	2.4945	2.5033	2.493	2.5312	2.5165	2.4969	2.5221	2.5082
    2.6478	2.6605	2.6371	2.6434	2.6257	2.6411	2.6278	2.6783	2.6546	2.6875	2.6453	2.6226	2.6919
    2.6129	2.6226	2.6266	2.6003	2.5875	2.5738	2.6076	2.5813	2.6456	2.5758	2.6121	2.5939	2.5936	
    4.0995	4.0854	4.1352	4.112	4.071	4.0582	4.1012	4.1446	4.1119	4.119	4.1025	4.0519	4.1384
    3.3157	3.3379	3.3053	3.3425	3.2795	3.3581	3.2935	3.2983	3.311	3.3448	3.334	3.3602	3.3272
    3.0966	3.0517	3.0809	3.12	3.098	3.0811	3.0946	3.1258	3.0917	3.1068	3.0919	3.0862	3.0649
    2.9379	2.969	2.9268	2.9605	2.9839	2.9172	2.9665	2.9204	2.9535	2.9071	2.9025	2.9051	2.9632
];

