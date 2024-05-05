funcFL=@(t) (30*sin(2*pi*t*2)+20*cos(2*pi*t*4));
funcFR=@(t) (35*sin(2*pi*t*1.5)+5*cos(2*pi*t*5));
funcRear=@(t) (32*sin(2*pi*t*2.5)+8*cos(2*pi*t*2));%(10*sin(2*pi*t*4).*exp(-t/5));
%funcFL=@(t) (0*t);
%funcFR=@(t) (0*t);
%funcRear=@(t) (0*t);
dt=0.001;
totalTime=5;

generateSimulationData(dt,totalTime,funcFL,funcFR,funcRear);

% wave function:
% -capital letter for absolute position, lowercase for
% function/relative
stepFunction=@(X,step_width,step_height,step_slopeIncoming,step_slopeRear,step_XStart)...
    ((step_slopeIncoming.*(X-step_XStart)+step_height).*all([step_slopeIncoming.*(X-step_XStart)+step_height>0;X>=step_XStart])+...
    (step_slopeRear.*(X-(step_XStart-step_width))+step_height).*all([step_slopeRear.*(X-(step_XStart-step_width))+step_height>0;X<=step_XStart-step_width])+...
    step_height*all([X>step_XStart-step_width;X<step_XStart]));
g_vectX=-10:0.01:-4;

terrain_Z=@(x) (stepFunction(x,0.5,40,-200,200,-5)+stepFunction(x,0.5,20,-20,20,-40));
terrain_Z2=@(x) (stepFunction(x,0.2,30,-200,200,-5));
cattleGrid_Z=@(x) (0);
for i=0:20
    cattleGrid_Z=@(x) cattleGrid_Z(x)+stepFunction(x,0.07,15,-1000,1000,-5-i*0.22);
end

velocity=5; % m/s
posFunctionZ=cattleGrid_Z;
plot(g_vectX*1000,posFunctionZ(g_vectX),'Color',[0,0,0]);
%axis equal
xlabel("x/mm")
ylabel("z/mm")
funcWave=@(x,t) (posFunctionZ(x-velocity*t));

FR_X=0;
FL_X=0;
Rear_X=2;

FR_Z=@(t) (funcWave(FR_X,t));
FL_Z=@(t) (funcWave(FL_X,t));
Rear_Z=@(t) (funcWave(Rear_X,t));
g_vectT=0:dt:totalTime;
figure
plot(g_vectT,FR_Z(g_vectT),'Color',[1,0,0])
xlabel("t/s")
ylabel("z/mm")
hold on
plot(g_vectT,FL_Z(g_vectT),'Color',[0,1,0])
plot(g_vectT,Rear_Z(g_vectT),'Color',[0,0,1])
hold off

generateSimulationData(dt,totalTime,FL_Z,FL_Z,Rear_Z);
generateSimulationData(dt,totalTime,funcFL,funcFR,funcRear);