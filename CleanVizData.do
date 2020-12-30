*******************************************
***Author: Yanlin Ren 
***Purpose: Clean and Visualize Airbnb data
*******************************************

*select variables of interest and merge monthly data into a single data file

*set working directory
    cd "Your/Folder/Path"
    set more off        //to eliminate scrolling for the results window
    pause on            //pause is a debug tool
*import and select vars for the listings


*201901
	*import csv
	import delimited 201901_listings.csv, bindquote(strict) maxquotedrows(unlimited) //bindquote and maxquote options are to ensure correct data importation

	*variables to keep
    global pineapple id last_scraped neighbourhood accommodates price weekly_price security_deposit cleaning_fee review_scores_rating reviews_per_month availability_365

	keep $pineapple
	save 201901_listing, replace
	
*201902
	import delimited 201902_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201902_listing, replace
	
*201903
	import delimited 201903_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201903_listing, replace
	
*201904
	import delimited 201904_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201904_listing, replace
	
*201905
	import delimited 201905_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201905_listing, replace
	
*201906
	import delimited 201906_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201906_listing, replace
	
*201907
	import delimited 201907_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201907_listing, replace
	
*201908
	import delimited 201908_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201908_listing, replace

*201909
	import delimited 201909_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201909_listing, replace
	
*201910
	import delimited 201910_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201910_listing, replace
	
*201911
	import delimited 201911_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201911_listing, replace
	
*201912
	import delimited 201912_listings.csv, bindquote(strict) maxquotedrows(unlimited) clear
	keep $pineapple
	save 201912_listing, replace
	
*merge 
	use 201901_listing, clear 
	append using 201902_listing 201903_listing 201904_listing 201905_listing 201906_listing 201907_listing 201908_listing 201909_listing 201910_listing 201911_listing 201912_listing
	save 2019alllisting, replace
	
********************************************************************************
*new vars start here
	use 2019alllisting, clear
	
*sort 
	sort id last_scraped
	
*generate a new time variabel
	gen scrapedate= date(last_scraped, "YMD")
	format scrapedate %td

*generate a new month variable
	gen month=1 if substr(last_scraped,6,2)=="01"
	replace month=2 if substr(last_scraped,6,2)=="02"
	replace month=3 if substr(last_scraped,6,2)=="03"
	replace month=4 if substr(last_scraped,6,2)=="04"
	replace month=5 if substr(last_scraped,6,2)=="05"
	replace month=6 if substr(last_scraped,6,2)=="06"
	replace month=7 if substr(last_scraped,6,2)=="07"
	replace month=8 if substr(last_scraped,6,2)=="08"
	replace month=9 if substr(last_scraped,6,2)=="09"
	replace month=10 if substr(last_scraped,6,2)=="10"
	replace month=11 if substr(last_scraped,6,2)=="11"
	replace month=12 if substr(last_scraped,6,2)=="12"
	
	label define mth 1 "January" ///
					 2 "Feburary" ///
					 3 "March" ///
					 4 "April" ///
					 5 "May" ///
					 6 "June" ///
					 7 "July" ///
					 8 "August" ///
					 9 "September" ///
					 10 "October" ///
					 11 "November" ///
					 12 "December"
					 
	label values month mth
	*tab month,m 
	*tab month, nolabel m
	
*generate a new price variabel
	gen pricent= substr(price,2,10)
	gen cleanfeet= substr(cleaning_fee,2,10)
	encode pricent, gen (priceperday)
	encode cleanfeet, gen (cleanfeec)
	replace cleanfeec=0 if cleanfeet==""
	gen pcn6night= (priceperday*6 + cleanfeec)/7.08
	gen p6nperppl= pcn6night/accommodates
	format p6nperppl %9.0f 

*generate new variales for neighbourhood
	gen district=1 if neighbourhood=="Bei Tai Ping Zhuang" | neighbourhood=="Beijing University" | neighbourhood=="Haidian" | neighbourhood=="Qinghe" | neighbourhood=="Shuangyushu" |  neighbourhood=="Summer Palace" | neighbourhood=="Suzhouqiao" | neighbourhood=="Weigongcun" |  neighbourhood=="Wudaokou" | neighbourhood=="Wukesong" | neighbourhood=="Xizhimen" | neighbourhood=="Zhongguancun" | neighbourhood=="Zizhuqiao" 
	
	replace district=2 if neighbourhood=="Beiyuan"
	
	replace district=3 if neighbourhood=="Caoqiao" | neighbourhood=="Dahongmen" | neighbourhood=="Fang Zhuang" | neighbourhood=="Fengtai" | neighbourhood=="Huaxiang" | neighbourhood=="Kaiyangli" |  neighbourhood=="Liuliqiao" | neighbourhood=="Qingta" | neighbourhood=="You'anmen" | neighbourhood=="Liuliqiao/Lize Bridge"
	
	replace district=4 if neighbourhood=="Chaoyang" | neighbourhood=="Chaoyang Park/Tuan Jie Hu" | neighbourhood=="Dawanglu" | neighbourhood=="Foreign Trade" | neighbourhood=="ITC" |  neighbourhood=="Jian Guo Men/Beijing Railway Station" | neighbourhood=="Jinsong/Panjiayuan" |  neighbourhood=="Jiuxianqiao" | neighbourhood=="Liang Ma Qiao/Sanyuanqiao" | neighbourhood=="Sanlitun" | neighbourhood=="Shilipu" |  neighbourhood=="Shuangjing" |  neighbourhood=="Wai Avenue" | neighbourhood=="Wangjing" | neighbourhood=="Zuojiazhuang"
	
	replace district=5 if neighbourhood=="Chongwenmen" | neighbourhood=="Dong Si" |  neighbourhood=="Dongcheng" | neighbourhood=="Dongzhimen" | neighbourhood=="Guangqumenwai" | neighbourhood=="Peace" |  neighbourhood=="Qianmen" |  neighbourhood=="Shazikou" | neighbourhood=="Temple of Heaven" |  neighbourhood=="Third Road Jucun/Liucun" | neighbourhood=="Wangfujing/Dongdan" 
	
	replace district=6 if neighbourhood=="Fuxingmennei" | neighbourhood=="Hu Fangqiao" | neighbourhood=="Niujie" | neighbourhood=="Shichahai" | neighbourhood=="Xicheng" | neighbourhood=="Xinjiekou" | neighbourhood=="Xuanwu" | neighbourhood=="Yue Tan" 
	
	replace district=7 if neighbourhood=="Zhuang" 
	
	
	
	label def cookiedough 1 "Chaoyang" /// 
						  2 "Haidian" ///
						  3 "Dongcheng" ///
						  4 "Xicheng" ///
						  5 "Fengtai" ///
						  6 "Tongzhou" ///
						  7 "Daxin" ///
						  
	label values district cookiedough
	
*count unique ids
	distinct id 
	//output: 64315


*drop 
	drop if neighbourhood=="" | neighbourhood=="Ahn Jung" |  neighbourhood=="Great Road"
	drop if district==.
	drop if availability_365==0
	drop if accommodates>4

*count unique ids
	distinct id
	//output: 35030
	
*egen mean for price by month
	egen mean1= mean(p6nperppl), by (month)
	format mean1 %9.0f 
	tab month mean1,m
	
*egen mean for price by disrtict 
	egen mean2= mean(p6nperppl), by(district)
	format mean2 %9.0f 
	tab district mean2,m

*egen mean for availability by month
	egen mean3= mean(availability_365), by (month)
	format mean3 %9.0f 
	tab month mean3,m

*egen mean for availability by district
	egen mean4= mean(availability_365), by(district)
	format mean4 %9.0f
	tab district mean4

	order id month district p6nperppl availability_365
	save bjairbnb, replace 
	
********************************************************************************
*save a new dataset with only several vars
	use bjairbnb, clear
	keep id month district p6nperppl availability_365
	save bjairbnbmodel, replace
	
*use the new dataset
	use bjairbnbmodel, clear 
	
*drop duplicates
	drop if id==4795169 & month==9
	drop if id==12550372 & availability_365==43
	drop if id==35533564 & month==10 & availability_365==365
 
*save
	save bjairbnbheatmap, replace 
	
	
*OLS with interaction term
	regress p6nperppl i.month i.district availability_365 month#district,r 
	margins month#district, cformat(%6.2f)

*saved output in word
*then copy pasted into excel. used text to coloumn function to transform
*saved the dataset into x y z format for heat map graphing

********************************************************************************
*import heat map ready dataset
	import excel using for_heatmap.xlsx, first clear 
	drop if price==.
	
*encode
	label define jumble  1 "January" ///
						 2 "Feburary" ///
						 3 "March" ///
						 4 "April" ///
						 5 "May" ///
						 6 "June" ///
						 7 "July" ///
						 8 "August" ///
						 9 "September" ///
						 10 "October" ///
						 11 "November" ///
						 12 "December"
	
	encode month, gen (month_n) label(jumble)
	label list 
	tab month_n
	tab month_n,nolabel
	
	
	label def cookiedough 1 "Chaoyang" /// 
						  2 "Haidian" ///
						  3 "Dongcheng" ///
						  4 "Xicheng" ///
						  5 "Fengtai" ///
						  6 "Tongzhou" ///
						  7 "Daxing" ///
	
	encode district, gen(district_n) label(cookiedough)
	label list
	tab district_n
	tab district_n,nolabel
	
	label list
	
*heatmap try
	heatplot price i.month_n i.district_n, xlabel(1 "Chaoyang" 2 "Haidian" 3 "Dongcheng" 4 "Xicheng" 5 "Fengtai" 6 "Tongzhou" 7 "Daxing", valuelabel angle(45)) color(Pink Red) ytitle("Month") xtitle("District") cuts(735 755 775 795 815 835 855 875 895 915 935 955 975)
	
	graph export price_red_hm.png, replace 
	
********************************************************************************
*second head map of availability
	use bjairbnbheatmap, clear 
	
*gen new ava var
	gen avapercent=availability_365/365

*egen
	egen mean7= mean(avapercent), by (month district)
	rename mean7 availability
	
*ava heat map different color
	heatplot availability i.month i.district, xlabel(1 "Chaoyang" 2 "Haidian" 3 "Dongcheng" 4 "Xicheng" 5 "Fengtai" 6 "Tongzhou" 7 "Daxing", valuelabel angle(45)) color(LightSkyBlue Blue) ytitle("Month") xtitle("District") cuts(0.57(0.01)0.72)
	
	graph export ava_blue_2.png, replace 

	
http://insideairbnb.com/get-the-data.html
