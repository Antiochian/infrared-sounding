function [ output ] = get_T (B,nu)
allowed_error = 0.0001;
converge_speed = 2;
step_size = 5;
%target B
Bt = B;
%first guess = room temperature
Tguess = 293;
Bguess = get_B(Tguess,nu);

%initiate loop
eval = Bt-Bguess;
prevflag = sign(eval);

bool = 0;
while bool == 0
    if eval == 0 %this will never happen
        bool = 1;
        output = Tguess;
    elseif sign(eval) ~= prevflag
        %sign change!
        if abs(step_size) < allowed_error
            bool = 1;
            output = Tguess;
        else
            step_size = -1*step_size/converge_speed;
            Tguess = Tguess + step_size;
        end
    else
        Tguess = Tguess + step_size;
    end
    prevflag = sign(eval);
    Bguess = get_B(Tguess,nu);
    eval = Bt-Bguess;   
      
%T loosely proprotinal to B

end