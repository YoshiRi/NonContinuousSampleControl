figure(2)
plot(time,x(1,:),'g--',timec,xest_c(1,:),'r*-',ytime,xest(1,:),'bo',ytime,xest_r(1,:),'kx:')
grid on 
xlabel('time [s]')
ylabel('Position')
legend('Ground Truth','Constant sample','Non-constant sample','Adaptive observer')
title('Pose Estimation')

figure(3)
plot(time,x(2,:),'g--',timec,xest_c(2,:),'r*-',ytime,xest(2,:),'bo-',ytime,xest_r(2,:),'kx:')
grid on 
xlabel('time [s]')
ylabel('Velocity')
legend('Ground Truth','Constant sample','Non-constant sample','Adaptive observer')
title('Vel Estimation')


figure(4)
plot(time,x(3,:),'g--',timec,xest_c(3,:),'r*-',ytime,xest(3,:),'bo-',ytime,xest_r(3,:),'kx:')
grid on 
xlabel('time [s]')
ylabel('Accerelation')
legend('Ground Truth','Constant sample','Non-constant sample','Adaptive observer')
title('Acc Estimation')
