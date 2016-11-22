function [ fixationBCs, fixationbcNames ] = GenfixationBCs(N)

% top node
top1=find(N(:,2)==min(abs(N(:,2))));
top1=N(top1,:);
top2=find(top1(:,3)==max(top1(:,3)));
top2=top1(top2,:);
top=top2

% bottom node
bottom1=find(N(:,2)==min(abs(N(:,2))));
bottom1=N(bottom1,:);
bottom2=find(bottom1(:,3)==min(bottom1(:,3)));
bottom2=bottom1(bottom2,:);
bottom=bottom2

% right node
right1=find(N(:,3)==min(abs(N(:,3))));
right1=N(right1,:);
right2=find(right1(:,2)==max(right1(:,2)));
right2=right1(right2,:);
right=right2

% left node
right1=find(N(:,3)==min(abs(N(:,3))));
right1=N(right1,:);
right2=find(right1(:,2)==min(right1(:,2)));
right2=right1(right2,:);
right=right2

fixationBCs=1
fixationbcNames=1