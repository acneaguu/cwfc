function [fit,ofcn,g,xn_out] = test_func_forBAP(iii,args,xx_yy)

global proc ps


% Rosenbrock’s function

ofcn=0;
for iscn_idx=1:1:length(xx_yy)-1
    sum=(100*(xx_yy(iscn_idx+1)-(xx_yy(iscn_idx))^2)^2+(xx_yy(iscn_idx)-1)^2);
    ofcn=ofcn+sum;
end
%Constraints (If there exist several constraints, g is a vector)
g=0;
%Fitness (ofcn+penalty*sum of constraints' violation)
fit=ofcn;

xn_out=xx_yy; %xn_out is update here only if an element of xx_yy is changed

%Update counter of function (problem) evaluation
proc.i_eval=proc.i_eval+1;

if proc.i_eval==1
    ps.ofcn_evol(proc.i_eval)=ofcn;
    ps.fit_evol(proc.i_eval)=fit;
    ps.param_evol(proc.i_eval,:)=xn_out;
end

if proc.i_eval>1
    if fit<ps.fit_evol(proc.i_eval-1)
        ps.ofcn_evol(proc.i_eval)=ofcn;
        ps.fit_evol(proc.i_eval)=fit;
        ps.param_evol(proc.i_eval,:)=xn_out;
    else
        ps.ofcn_evol(proc.i_eval)=ps.ofcn_evol(proc.i_eval-1);
        ps.fit_evol(proc.i_eval)=ps.fit_evol(proc.i_eval-1);
        ps.param_evol(proc.i_eval,:)=ps.param_evol(proc.i_eval-1,:);
    end
    
end

if ((proc.i_eval==1)||(mod(proc.i_eval,args{2})==0))& args{1}
    fprintf('Trial: %5d,   i_eval: %7d,   fitness: %12.7E \n',...
        iii,proc.i_eval,ps.fit_evol(proc.i_eval));
end

if proc.i_eval>=proc.n_eval 
    proc.finish=1;
end



end