for i=1:2487
a=dicominfo(['input\0 (' num2str(i) ').dcm']);
b=dicominfo(['output\0 (' num2str(i) ').dcm']);
if a.SliceLocation==b.SliceLocation
    disp(["OK@-",num2str(i)]);
else
    disp(["fialed@-",num2str(i)]);
end
end