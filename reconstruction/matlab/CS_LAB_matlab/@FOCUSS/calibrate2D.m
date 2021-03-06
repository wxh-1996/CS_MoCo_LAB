function kernel = calibrate2D(obj, AtA, nCha, coil)
% retrieve calibration kernel from 2D calibration region
%
% (c) Thomas Kuestner 
% ---------------------------------------------------------------------

sampling = ones([obj.kernelSize,nCha],obj.measPara.precision);

dummyK = zeros(obj.kernelSize(1),obj.kernelSize(2),nCha,obj.measPara.precision); 
dummyK((end+1)/2,(end+1)/2,coil) = 1;
idxY = find(dummyK);
sampling(idxY) = 0;
idxA = find(sampling);

Aty = AtA(:,idxY); Aty = Aty(idxA); % correlation values to target point, take complete neighbourhood and not just aquired ones
AtA = AtA(idxA,:); AtA =  AtA(:,idxA); % kick out the searched point

kernel = sampling*0;

lambda = norm(AtA,'fro')/size(AtA,1)*obj.calibTyk;

cnd = cond(AtA + eye(size(AtA))*lambda);
if(cnd == inf)
    rawkernel = pinv(AtA + eye(size(AtA))*lambda)*Aty; % grappa weighting values
else
    rawkernel = (AtA + eye(size(AtA))*lambda)\Aty; % grappa weighting values    
end
kernel(idxA) = rawkernel; 

end