function [out1,out2]=datalod(start,endd)



namelis={};
for i=start:endd
   name=['input\0 (' num2str(i) ').dcm'];
   namelis{i-start+1}=name;
end
imdsinput= imageDatastore(namelis,FileExtensions='.dcm',ReadFcn=@(x)dicomread(x),ReadSize=500);

for i=start:endd
   name=['output\0 (' num2str(i) ').dcm'];
   namelis{i-start+1}=name;
end
imdsoutput= imageDatastore(namelis,FileExtensions='.dcm',ReadFcn=@(x)dicomread(x),ReadSize=500);



out1=transform(imdsinput,@trans1);
out2=transform(imdsoutput,@trans2);




end


function out=trans1(in)
out=cell(size(in));
for i=1:size(in,1)
out{i}=double(in{i})/4096;
end

end

function out=trans2(in)

out=cell(size(in));
for i=1:size(in,1)
out{i}=double(in{i})/4096;
end
end
