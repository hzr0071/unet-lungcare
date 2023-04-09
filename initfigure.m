function figs=initfigure(num,name)

figs=cell(num,1);
for i=1:num
figure('Name',name(i));
figs{i}=nexttile;

end


end