%% 

%% Make truth data
dt  = 1e-4
A = [1 dt 0; 0 1 dt; 0 0 1];
B = [0;0;1];
C = [1,0,0];
x0 = [0;0;0];
omega = 0.8*2*pi;

len = 1e4;

x = zeros(3,len);
time = 0:dt:dt*(len-1);
x(:,1) = x0;

for i = 2:len
x(:,i) = A * x(:,i-1) + B * 0.3 * cos(omega*i*dt);
end

%% Estimation

st = 1e-2
Srate = st/dt;
random_seed_length = len/Srate*1.2;
random_sampling_interval = round(Srate + 10 * randn(1,random_seed_length));
random_sampling = cumsum(random_sampling_interval);

random_sampling(random_sampling > len) = [];

ylen = length(random_sampling);
y = zeros(1,ylen);
y_n = zeros(1,ylen);
y_c = zeros(1,len/Srate);
measure_n = 0.1;
noise = measure_n*randn(1,ylen);
ytime = dt*random_sampling;
timec = 0:st:st*(len/Srate - 1);


count = 1;
for i = 2:len
if sum(random_sampling == i)
    y(1,count) = C*x(:,i);
    y_n(1,count) = y(1,count) + noise(1,count);
    count = count+1;
end
end

%% showing

figure(1)
plot(time,x(1,:),'g--',ytime,y,'r*-',ytime,y_n,'bo')
grid on;
legend('GroundTruth','Measure','Measure w/noise','Location','Best')
