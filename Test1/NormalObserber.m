%%
% Already know A,B,...

Ao = [1 st 0; 0 1 st; 0 0 1];
xest = zeros(3,ylen);
xest_c = zeros(3,len/Srate);
xest_r = zeros(3,ylen);
poles = -[10*2*pi 13*2*pi 15*2*pi];
zpoles = exp(poles*st);
K = place(Ao',(C)',zpoles).';

% constant
for i = 2:len/Srate
    err = C*x(:,(i-1)*Srate) - C * xest_c(:,i-1);
    xest_c(:,i) = Ao * xest_c(:,i-1) + K * err;
end


% non-constant
for i = 2:ylen
    yest = C*xest(:,i-1);
    err = y(:,i-1)-yest;
    xest(:,i) = Ao * xest(:,i-1) + K * err;
end

% 
for i = 2:ylen
    err = C*x(:,random_sampling(i-1)) - C * xest_r(:,i-1);
    td =  dt*(random_sampling(i)-random_sampling(i-1));
    Ar = [1 td 0; 0 1 td; 0 0 1];
    Kr = place(Ar',(C)',exp(poles*td) ).';
    xest_r(:,i) = Ar * xest_r(:,i-1) + Kr * err;
end

