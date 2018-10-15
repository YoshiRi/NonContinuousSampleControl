
clear
close all

%% model 

num = [0.0025 0.35 10];
den = [0.0005 0.105 1];
sys = tf(num,den)

ST = 10e-6;
SIMEND = 5.0;


%% Get Continuous time simulation
%sim('test_sine.slx')
sim('test_step.slx')

%% Determine DT
DT = 1/100;
Srate = DT/ST;
LEN = SIMEND/ST + 1; 
len = SIMEND/DT + 1;

random_seed_length = floor(len*1.2);
MODE = 2;

if MODE == 1
    random_sampling_interval = round(Srate + 50 * randn(1,random_seed_length));
elseif MODE == 2
    random_sampling_interval = 1:random_seed_length;
    random_sampling_interval(random_sampling_interval >= 3/DT) = round(2*Srate);
    random_sampling_interval(random_sampling_interval < 3/DT) = round(Srate);
    random_sampling = cumsum(random_sampling_interval);
end

% discard data
random_sampling(random_sampling > LEN) = [];

% get data
dtime = y_c.time(random_sampling);
y_d = y_c.Data(random_sampling);
yd_orig = y_orig.Data(random_sampling);


ylen = length(random_sampling);    
%% Estimation
%  1. Tustin continuous
sys_dc = c2d(sys,DT,'tustin');
ssdc = ss(sys_dc);
x1 =  zeros(1,ylen);

for i = 3:ylen
    %deltaT = dtime(i)-dtime(i-1);
    x1(i) = cell2mat(sys_dc.num)  * [yd_orig(i) yd_orig(i-1) yd_orig(i-2)]' - cell2mat(sys_dc.den) *[0 x1(i-1) x1(i-2)]';
end

%  2. Tustin non continuous
sys_dc2 = c2d(sys,2*DT,'tustin');
ssdc2 = ss(sys_dc2); %50Hz version

x2 =  zeros(1,ylen);

for i = 3:ylen
    %deltaT = dtime(i)-dtime(i-1);
    
    if random_sampling_interval(i) == round(Srate)
        x2(i) = cell2mat(sys_dc.num)  * [yd_orig(i) yd_orig(i-1) yd_orig(i-2)]' - cell2mat(sys_dc.den) *[0 x2(i-1) x2(i-2)]';
    else
        x2(i) = cell2mat(sys_dc2.num)  * [yd_orig(i) yd_orig(i-1) yd_orig(i-2)]' - cell2mat(sys_dc2.den) *[0 x2(i-1) x2(i-2)]';
    end
end


%%
figure(1)
 plot(dtime,yd_orig,'y',dtime,y_d,'g',dtime,x1,'r--',dtime,x2,'b-.')
 legend('Input','Continuous Result','Constant Filter','Adaptive Filter')
 
figure(2)
 plot(dtime(1:end-1),diff(dtime))
 