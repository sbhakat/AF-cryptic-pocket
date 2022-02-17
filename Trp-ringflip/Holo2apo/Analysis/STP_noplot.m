function [y,ECDF]=STPtest(times_vector,mintime,maxtime,nbins,alpha,waitingbins,totsim)
%   STPtest performs the tests described in "Assessing the reliability 
%   of dynamics reconstructed from metadynamics", M.Salvalaglio, P.Tiwary and 
%   M. Parrinello, (submitted) on a data set of transition times. If you
%   use this tool for research leading to a publication, please cite the
%   following two references:
%   1. M.Salvalaglio, P.Tiwary and M. Parrinello, (submitted)
%   2. P. Tiwary and M. Parrinello, Phys. Rev. Lett. 111 (230602) 2013.
%
%   The function should be used as: 
%   H = STPtest(times_vector,mintime,maxtime,nbins,alpha,waitingbins,totsim)
%           
%   where 
%   times_vector: is a vector containing the transition times series    
%   mintime:      is a scalar, indicating the lower bound for the
%                 time domain over which the ECDF is built
%   maxtime:      is a scalar, indicating the upper bound for the
%                 time domain over which the ECDF is built
%   nbins:        is a scalar, indicating the number of bins in which
%                 the time domanin is discretized
%   alpha:        (optional, default=0.05) is a scalar, indicating the 
%                 significance level for the Kolmogorov-Smirnov test.
%   waitingbins   (optional, default=sqrt(length(times_vector)) is a scalar
%                 indicates the number of bins to be used to construct the
%                 empirical distribution of waiting times plotted in Fig. 2 
%   totsim:       (optional, default=length(times_vector)) is a scalar, 
%                 specifies the total number of simulations both showing 
%                 and not showing transition. 
%
%   Note that to specify the nth argument, all the n-1 argument must 
%   specified.
%
%   As an output the CDF and (optionally) PDF are plotted and a structure 
%   with the following fields is generated: 
%   
%   mu:                  average of the transition times data set
%   sigma:               standard deviation of the transition times data 
%                        set
%   t_m:                 median of the transition times data set 
%   tau:                 fitted characteristic time of the Poisson process
%   mu_sigma_ratio:      ratio between average and standard deviation, 
%                        it should be close to one for waiting times 
%                        exponentially distributed.
%   log2mu_median_ratio: it should be close to one for waiting times 
%                        exponentially distributed.
%   tau_mu_ratio:        ratio between the average and the predicted 
%                        transition time of the Poisson Process, 
%                        should be close to one for a well 
%                        sampled distribution of times 
%   pvalue_KS_statistic: pvalue associated with the KS statistic 
%                        calculated with kstest2 
%   Reject:              0 if the the null hypothesis that the theoretical 
%                        and empirical CDFs are the same distribution 
%                        cannot be rejected within the assigned level
%                        of significance, 1 otherwise. 
%                        See kstest2 for more details.
%
%
%   Last revision 21/2/2014 


if nargin < 4
    error('At least 4 inputs are required. Type help STPtest for further details.');
end

if nargin==4
   totsim=length(times_vector);
   alpha=0.05; 
   waitingbins=floor(sqrt(length(times_vector)));
end

if nargin==5
   totsim=length(times_vector);
   waitingbins=floor(sqrt(length(times_vector)));
end
 
if nargin==6
   totsim=length(times_vector);
end


if nargin==7
   if totsim~=length(times_vector)
   maxtime=max(times_vector);
   disp(' ')
   disp('Warning!')
   disp('As an incomplete set of simulations is considered,')
   disp('maxtime has been set to max(times_vector):')
   disp(maxtime)
   disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
   disp('Warning: VERY IMPORTANT')
   disp('In this case the p-value and the result of the KS test are not meaningful')
   disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
   end
end


if mintime==0
   mintime=mintime+eps;
   disp(' ')
   disp('Warning!')
   disp('Mintime cannot be 0. The new mintime has been set to:')
   disp(mintime)
   disp(' ')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Empirical T1 entries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAW DATA INDICATORS:  
  % average (mu)
  % standard deviation (sigma)
  % median (t_m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu=mean(times_vector);
sigma=std(times_vector);
t_m=median(times_vector);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescaling of the transition times with respect to the mean to avoid
% numerical issues in the fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

times_vector=times_vector./mu;
mintime=mintime./mu;
maxtime=maxtime./mu;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building the ECDF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Define the time domain
time=logspace(log10(mintime),log10(maxtime),nbins);

% Build the ECDF

binCounts  =  histc (times_vector , time, 1);




ECDF  =  cumsum(binCounts)./totsim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fitting the ECDF with Eq.(2) Ref. 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the analytical expression of the CDF
g=fittype('(1-exp(-rate.*(time)))','independent',{'time'}); 

% Use the average as an educated guess for the 1./rate
x0=1./mu;

% Fitting options
options = fitoptions('Display','final','Method','NonlinearLeastSquares','StartPoint',x0,'Lower',0,'Upper',maxtime,'MaxIter',100000000,'TolFun',1.0000e-07,'Robust','on');
                 
% Fitting             
fP = fit( time', ECDF, g, options);

% Tau
tau=fP.rate.^-1;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Theoretical Cumulative Distribution Function
% TCDF=gamcdf(time,1,tau);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KS test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Large theoretical distribution
theoretical_times=gamrnd(1,tau,1,length(times_vector).*1E5);
% 
% %Kolmogorov-Smirnov test: 
[HT1,pvalueT1]=kstest2(times_vector,theoretical_times,alpha);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tau (reconverted back to scale)
tau=mu.*tau;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FIGURES: CDF
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hFig=figure(1);
% set(hFig,'Position',[100 100 600 500])
% % ECDF
% %subplot(1,2,1)
% stairs(time'.*mu,ECDF,'k','MarkerSize',10,'MarkerFaceColor','w','Linewidth',1.0)
% set(gca,'XScale', 'log');
% hold on
% % TCDF 
% plot(time.*mu,TCDF,'r','MarkerSize',10,'MarkerFaceColor','w','Linewidth',2.0)
% xlim([mintime.*mu maxtime.*mu])
% xlabel('Time','Fontsize',22)
% ylabel('P_{n\geq{1}}','Fontsize',22)
% set(gca,'FontSize',16)
% title('CDF')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hFig=figure(2);
% set(hFig,'Position',[100 100 600 500])
% % subplot(1,2,2)
% [T1,X]=hist(times_vector,waitingbins);
% T1=T1./trapz(X,T1);
% plot(X,T1,'ko','MarkerSize',10,'MarkerFaceColor','w','Linewidth',1.0)
% hold on
% P=gampdf(time,1,fP.rate.^-1);
% plot(time,P,'r-','MarkerSize',10,'MarkerFaceColor','w','Linewidth',2.0)
% xlabel('Time','Fontsize',20)
% ylabel('f_{T1}','Fontsize',20)
% set(gca,'FontSize',16)
% xlim([min(times_vector) max(times_vector)])
% title('PDF')


y=struct('mu',mu,...
         'mu_sem',sigma./sqrt(length(times_vector)),... 
         'sigma',sigma,...
         't_m',t_m,...
         'tau',tau,...
         'mu_sigma_ratio',mu./sigma,...
         'log2mu_median_ratio',log(2).*mu./t_m,...
         'tau_mu_ratio',tau./mu,...
         'pvalue_KS_statistic',pvalueT1,...
         'Reject',HT1);

end

