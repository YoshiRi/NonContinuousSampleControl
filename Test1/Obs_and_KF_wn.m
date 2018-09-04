% ÉçÉnå^Ç≈Ç‚ÇËÇ‹Ç∑
%%
% Already know A,B,...

Ao = [1 st 0; 0 1 st; 0 0 1];
xest = zeros(3,ylen);
xest_c = zeros(3,len/Srate);
xest_r = zeros(3,ylen);
poles = -[10*2*pi 13*2*pi 15*2*pi];
zpoles = exp(poles*st);
K = place(Ao',(C*Ao)',zpoles).';



% non-constant
for i = 2:ylen
     err = y_n(:,i)- C*Ao*xest(:,i-1);
    xest(:,i) = Ao * xest(:,i-1) + K * err;
end

% 
for i = 2:ylen
    td =  dt*(random_sampling(i)-random_sampling(i-1));
    Ar = [1 td 0; 0 1 td; 0 0 1];

    err = y_n(:,i) - C * Ar* xest_r(:,i-1);
    Kr = place(Ar',(C*Ar)',exp(poles*td) ).';
    xest_r(:,i) = Ar * xest_r(:,i-1) + Kr * err;
end


%% KF

Pinit = 10000*eye(3);
s_sys =  0.1;
s_obs = 1e-10;

xest_kf = zeros(3,ylen);
P = zeros(3,3,ylen);
P(:,:,1)=Pinit;
xest_kf(:,1) = x(:,random_sampling(1));
for i = 2:ylen
    td =  dt*(random_sampling(i)-random_sampling(i-1));
    Ar = [1 td 0; 0 1 td; 0 0 1];
    Br = [0;td*td/2;td]*s_sys;
    xe = Ar * xest_kf(:,i-1);
    Pe = Ar * P(:,:,i-1) * Ar' + Br*Br';
    
    Kf = Pe*C'*inv(C*Pe*C'+s_obs);
    xest_kf(:,i) = xe + Kf*(y_n(:,i)-C*xe);
    P(:,:,i) = (eye(3)-Kf*C)*Pe;
end


%% show 

figure(2)
plot(time,x(1,:),'g--',ytime,xest(1,:),'bo',ytime,xest_r(1,:),'kx:',ytime,xest_kf(1,:),'m-.')
grid on 
xlabel('time [s]')
ylabel('Position')
legend('Ground Truth','Non-constant sample','Adaptive observer','Kalman Filter')
title('Pose Estimation')

figure(3)
plot(time,x(2,:),'g--',ytime,xest(2,:),'bo-',ytime,xest_r(2,:),'kx:',ytime,xest_kf(2,:),'m-.')
grid on 
xlabel('time [s]')
ylabel('Velocity')
legend('Ground Truth','Non-constant sample','Adaptive observer','Kalman Filter')
title('Vel Estimation')


figure(4)
plot(time,x(3,:),'g--',ytime,xest(3,:),'bo-',ytime,xest_r(3,:),'kx:',ytime,xest_kf(3,:),'m-.')
grid on 
xlabel('time [s]')
ylabel('Accerelation')
legend('Ground Truth','Non-constant sample','Adaptive observer','Kalman Filter')
title('Acc Estimation')
