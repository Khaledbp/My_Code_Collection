function [idx] = ladderinregion(startn,endn,ladder)

a=ladder(:,1)>=startn;
b=ladder(:,2)<=endn;
idx=find(a+b==2);

%{
startn=9932270+5;
endn=9964582+5;
ladder=[    
     9928776     9928911;
     9930696     9930766;
     9932178     9932270;   

     9936234     9936313;
     9938241     9938346;
     9941955     9942035;
     9943805     9943866;
     9955723     9955811;
     9955910     9955991;
     9956808     9956868;
     9963779     9963843;

     9964582     9964645;
     9964792     9964891;
     9966539     9966658;
     9973137     9973298;
     9974784     9974834;
     9981612     9981671;
     9990946     9990999;
     9991880     9991933;
     9993163     9993216;
     9995594     9995604]
%}