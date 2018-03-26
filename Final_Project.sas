/* Final Project CS593

Movie Rating Prediction Using Regresssion technique

Vicky Rana
Advait Gupte
Bipin Pandey
Vivek Ganjave 

*/



libname project "E:\Data Mining 2\Project\imdb-5000-movie-dataset\";

options compress=yes;

/* Coverting XLS data to CSV*/
PROC IMPORT OUT= WORK.movie 
            DATAFILE= "E:\Data Mining 2\Project\imdb-5000-movie-dataset\movie_metadata.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     /*DATAROW=2;*/ 
RUN;

proc contents data=movie; run;

proc contents data=movie out=movie_details_1;
run;
/* Cleaning of the Data*/
/* Starting with removing NA values*/
/*data Movie_wo_na;
     set Movie;
     if missing(actor_1_facebook_likes,actor_1_name)  then delete;
     run;*/

 data Movie_wo_na;
     set Movie;
	 if nmiss(of _numeric_)+ cmiss(of _character_) > 0 then delete;
	 run;

/* Removing unwanted variables*/

data Movie_rm_var;
	set Movie_wo_na;
	DROP genres actor_1_name color director_name actor_2_name actor_1_name movie_title actor_3_name plot_keywords movie_imdb_link language country content_rating;
	run;

/* Plotting a Histogram*/

ods graphics on;
proc univariate data=Movie_rm_var;
histogram imdb_score;
run;
quit;

/* Renaming the variable*/
data movie_final_cat; set movie_rm_var;
	rename
	num_user_for_reviews = user_rev 
	actor_1_facebook_likes = act1_like
	actor_2_facebook_likes = act2_like
	actor_3_facebook_likes = act3_like
	aspect_ratio = ratio
	cast_total_facebook_likes = cast_like
	director_facebook_likes = dir_like
	facenumber_in_poster = poster
	movie_facebook_likes = mov_like 
	num_critic_for_reviews = critic_rev
	num_voted_users = user_vote
	title_year = year;
run;


proc means data=movie_final_cat;
var act1_like act2_like act3_like budget cast_like critic_rev dir_like duration gross mov_like poster ratio user_rev user_vote year imdb_score;
	run;

/* Turning Target variable and predictors into Categorical*/
data Movie_final;
	set Movie_final_cat;

	if dir_like <=11 then dir_like=0;
	else if dir_like >11 and dir_like <=64 then dir_like=1;
	else if dir_like >64 and dir_like <=235 then dir_like=2;
	else dir_like=3;

	if act3_like <=194 then act3_like=0;
	else if act3_like >194 and act3_like <=436 then act3_like=1;
	else if act3_like >436 and act3_like <=691 then act3_like=2;
	else act3_like=3;

	if act1_like <=745 then act1_like=0;
	else if act1_like >745 and act1_like <=1000 then act1_like=1;
	else if act1_like >1000 and act1_like <=13000 then act1_like=2;
	else act1_like=3;

	if gross <=8261449 then gross=0;
	else if gross >8261449 and gross <=30093107 then gross=1;
	else if gross >30093107 and gross <=66901814 then gross=2;
	else gross=3;

	if user_vote <=19663 then user_vote=0;
	else if user_vote >19663 and user_vote <=53973 then user_vote=1;
	else if user_vote >53973 and user_vote <=128611 then user_vote=2;
	else user_vote=3;


	if cast_like <=1919 then cast_like=0;
	else if cast_like >1919 and cast_like <=4059 then cast_like=1;
	else if cast_like >4059 and cast_like <=16243 then cast_like=2;
	else cast_like=3;


	if poster <=0 then poster=0;
	else if poster >0 and poster <=1 then poster=1;
	else if poster >1 and user_vote <=2 then poster=2;
	else poster=3;

	if user_rev <=110 then user_rev=0;
	else if user_rev >110 and user_rev <=210 then user_rev=1;
	else if user_rev >210 and user_rev <=398 then user_rev=2;
	else user_rev=3;


	if budget <=10000000 then budget=0;
	else if budget >10000000 and budget <=25000000 then budget=1;
	else if budget >25000000 and budget <=50000000 then budget=2;
	else budget=3;


	if year <=1999 then year=0;
	else if year >1999 and year <=2004 then year=1;
	else if year >2004 and year <=2010 then year=2;
	else year=3;

	if act2_like <=384 then act2_like=0;
	else if act2_like >384 and act2_like <=685 then act2_like=1;
	else if act2_like >685 and act2_like <=976 then act2_like=2;
	else act2_like=3;

	if imdb_score <=5.9 then imdb_score_cat=0;
	else if imdb_score >5.9 and imdb_score <=6.6 then imdb_score_cat=1;
	else if imdb_score >6.6 and imdb_score <=7.2 then imdb_score_cat=2;
	else imdb_score_cat=3;

	if ratio <=1.85 then ratio=0;
	else if ratio >1.85 and ratio <=2.35 then ratio=1;
	else if ratio >2.35 and ratio <=2.35 then ratio=2;
	else ratio=3;

	if mov_like <=0 then mov_like=0;
	else if mov_like >0 and mov_like <=227 then mov_like=1;
	else if mov_like >227 and mov_like <=11000 then mov_like=2;
	else mov_like=3;

	if critic_rev <=77 then critic_rev=0;
	else if critic_rev > 77 and critic_rev <=77 then critic_rev=1;
	else if critic_rev > 77 and critic_rev <=224 then critic_rev=2;
	else critic_rev=3;

	if duration <=96 then duration=0;
	else if duration > 96 and duration <=106 then duration=1;
	else if duration > 106 and duration <=120 then duration=2;
	else duration=3;


	if imdb_score >= 6.6 then rating=0;
	else rating=1;
run;

proc contents data=movie_final; run;

proc contents data=movie_final out=movie_details_2;
run;


/*Plotting Variables";*/
ods graphics on;
proc sgplot data=movie_final;
	scatter x=imdb_score y=user_rev;
	ellipse x=imdb_score y=user_rev;
	run;
	quit;

proc sgplot data=movie_final;
	scatter x=imdb_score y=user_vote;
	ellipse x=imdb_score y=user_vote;
	run;
	quit;

proc sgplot data=movie_final;
	scatter x=imdb_score y=dir_like;
	ellipse x=imdb_score y=dir_like;
	run;
	quit;




/* Normalize the data */

/*
proc standard data=movie_final
	mean=0 std=1
	OUT=movie_final;
	var act1_like act2_like act3_like budget cast_like critic_rev dir_like duration gross mov_like poster ratio user_rev user_vote year imdb_score;
	run;*/
									


/* Logistic Regression */

proc logistic data=movie_final descending;  
class act1_like (ref='0') act2_like (ref='0') act3_like (ref='0') budget(ref='0') cast_like(ref='0') critic_rev(ref='0') dir_like(ref='0')
duration (ref='0')gross(ref='0') mov_like(ref='0') poster(ref='0') ratio(ref='0') user_rev(ref='0') user_vote(ref='0') year(ref='0') / param=ref;
model rating=act1_like act2_like act3_like budget cast_like critic_rev dir_like duration gross mov_like poster ratio user_rev user_vote year
										;
quit;


/** Applying Logistic regression after removing insignificant variable */
proc logistic data=movie_final descending;  
class  budget(ref='0') cast_like(ref='0') critic_rev(ref='0') dir_like(ref='0')
duration (ref='0')gross(ref='0') mov_like(ref='0') poster(ref='0') user_rev(ref='0') user_vote(ref='0') year(ref='0') / param=ref;
model rating= budget cast_like critic_rev dir_like duration gross mov_like poster user_vote year user_rev
										;
quit;


/* Principle Component Analysis */

proc corr data=movie_final;
	var budget cast_like critic_rev dir_like duration gross mov_like poster user_rev user_vote year;
	run;

/* Normalization*/
PROC STANDARD DATA=movie_final MEAN=0 STD=1 
                OUT=movie_final_pca;
  VAR  budget cast_like critic_rev dir_like duration gross mov_like poster user_rev user_vote year;
	run;

proc princomp data=movie_final_pca out=movie_pca;
var budget cast_like critic_rev dir_like duration gross mov_like poster user_rev user_vote year;
	run;

proc corr data=movie_pca cov;
	var Prin1-Prin11;
run;


**PCA WITH FOUR COMPONENT;
proc princomp data=movie_pca n=4 out=movie_prin_pca;
var budget cast_like critic_rev dir_like duration gross mov_like poster user_rev user_vote year;
	run;

*Plotting Principle Components;

proc plot data=movie_prin_pca;
plot prin3*prin4;
run;

proc plot data=movie_prin_pca;
plot prin1*prin2;
run;




/*Divide the Movie dataset into two
separate datasets (MV1 and MV2)*/
data MV1 MV2;
   set movie_prin_pca ;
    id=1000+_n_;
  if  mod(id,2)=0 then output MV1;
  else output MV2;
run;

/*data mv1 mv2;
	set movie_prin_pca;
	if mod(_n_,2) = 0 then output mv1;
	else output mv2;
run;*/

proc means data=mv1;
var prin1 prin2 prin3 prin4;
run;

/*logistic gression for Mv1*/
proc logistic data=mv1 descending outmodel=mv1_model;  
model rating=prin1 prin2 prin3 prin4;
quit;

proc means data=mv2;
var prin1 prin2 prin3 prin4;
run;

/*logistic gression for Mv2*/
proc logistic data=mv2 descending outmodel=mv2_model;  
model rating=prin1 prin2 prin3 prin4;
quit;

proc freq data=mv2 ;
   table rating/out=prior_dist2(rename=count=_prior_ drop=percent)  ;
run;

 proc logistic inmodel=mv2_model;
      score data=mv1 
             out=mv1_score  ;
      
   run;
*prior=prior_dist2 fitstat;

proc contents data=mv1_score;
run;

proc freq data=mv1_score;
    table F_rating*I_rating;
run;
quit;











	 

