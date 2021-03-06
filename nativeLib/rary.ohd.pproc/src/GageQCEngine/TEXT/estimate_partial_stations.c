#include <math.h>

#include "gageqc_defs.h"
#include "gageqc_types.h"

void estimate_partial_stations(int j,
		               struct station * station,
			       int max_stations)

{

extern int isom;
extern int isohyets_used;
extern int mpe_dqc_max_precip_neighbors;
extern int mpe_dqc_min_good_stations;
extern struct pdata pdata[10];
extern int method;
extern struct pdata pdata[];

int m,k,i,l,ii;
double lat1,lon1,fdist,fdata,fvalue[4],lat,lon,testdist,ftotal,isoh=0.,isoh1=0.,padj;

if(pdata[j].data_time==0)
                     return;

/* this routine will estimate 6 hourly periods when 24 hour rain exists */

for(m=0;m<max_stations;m++) {

          /* search for a good 6 hourly period */

          for(k=0;k<4;k++) {
          
               if(pdata[j].stn[m].rain[k].data >= 0 &&              
                 (pdata[j].stn[m].frain[k].qual==0 ||            
                  pdata[j].stn[m].frain[k].qual==8 || 
                  pdata[j].stn[m].frain[k].qual==3 ||
		  pdata[j].stn[m].frain[k].qual==2))
                               break;

	     }

          if(k==4) {
          
              /* all 6 hourly periods missing or set bad */
              /* need to re-estimate 24 hour data */ 
          
              if(pdata[j].stn[m].frain[4].data >= 0 &&
                 pdata[j].stn[m].frain[4].qual == 4) {
                 
                          pdata[j].stn[m].frain[4].qual =0;
                          pdata[j].stn[m].frain[4].data =-1;
          }
          
                    continue;
          
          
              }
                             
          /* dont estimate if 24 hour station available */

          if(pdata[j].stn[m].frain[4].data >= 0 &&
             pdata[j].stn[m].frain[4].qual != 4 &&
             pdata[j].stn[m].frain[4].qual != 5)
                               continue;
   
          /* at least  one missing 6 hourly period found */

          lat1=station[m].lat;
          lon1=station[m].lon;

          /*get isohyet */

          if(isohyets_used!=0)
                 isoh1=station[m].isoh[isom];

	  /* first */       
	  
	  for(k=0;k<4;k++) {

             fdist=0.0;
             fdata=0.0;

             l=0;

             for(ii=0;ii<mpe_dqc_max_precip_neighbors;ii++){

                 i=station[m].index[ii]; 

                 /* dont estimate unless good or forced good */

                 if(pdata[j].stn[i].frain[k].qual!=0 &&
                    pdata[j].stn[i].frain[k].qual!=8 &&
                    pdata[j].stn[i].frain[k].qual!=3 &&
                    pdata[j].stn[i].frain[k].qual!=6 &&
		    pdata[j].stn[i].frain[k].qual!=2)
                                          continue;
	     
                 /*dont use missing stations */
                 
                 if(pdata[j].stn[i].frain[k].data < 0)
                                          continue;

                 lat=station[i].lat;
                 lon=station[i].lon;

                 if(isohyets_used != 0)
                        isoh=station[i].isoh[isom];

                 testdist= pow((double)(lat1-lat),2) +
                           pow((double)(lon1-lon),2);

                 if(testdist==0.0)
                             testdist=.000001;

                 if(method==2 && isoh > 0 && isoh1 > 0)
                      padj=pdata[j].stn[i].frain[k].data*isoh1/isoh;
 
                 else
                      padj=pdata[j].stn[i].frain[k].data;
 
                 fdist=1/testdist+fdist;
                 fdata=padj/testdist + fdata;
                 l++;

	       }	 

             if(l < mpe_dqc_min_good_stations) {

             fdist=0.0;
             fdata=0.0;

             l=0;

             for(i=0;i<max_stations;i++){
                  
                 if(i==m)
                      continue;

                 if(pdata[j].stn[i].frain[k].qual!=0 &&
                    pdata[j].stn[i].frain[k].qual!=8 &&
                    pdata[j].stn[i].frain[k].qual!=3 &&
                    pdata[j].stn[i].frain[k].qual!=6 &&
		    pdata[j].stn[i].frain[k].qual!=2)
                                          continue;

                 if(pdata[j].stn[i].frain[k].data < 0)
                                          continue;

                 lat=station[i].lat;
                 lon=station[i].lon;

                 if(isohyets_used != 0)
                        isoh=station[i].isoh[isom];

                 testdist= pow((double)(lat1-lat),2) +
                           pow((double)(lon1-lon),2);

                 if(testdist==0.0)
                             testdist=.0001;

                 if(method==2 && isoh > 0 && isoh1 > 0)
                      padj=pdata[j].stn[i].frain[k].data*isoh1/isoh;
 
                 else
                      padj=pdata[j].stn[i].frain[k].data; 

                 fdist=1/testdist+fdist;
                 fdata=padj/testdist + fdata;
                 l++;
	     }
           
	     }

           if(l != 0)
               fvalue[k]=fdata/fdist;
               
           else
               fvalue[k]=-9999;

	   }
            
            
       /* have good and estimated periods */
           
            
       if(fvalue[0]==-9999 ||
          fvalue[1]==-9999 ||
          fvalue[2]==-9999 ||
          fvalue[3]==-9999) 
                        continue;
          
        ftotal=0;
        
	for(k=0;k<4;k++) {

              if(pdata[j].stn[m].rain[k].data >= 0 &&
                 (pdata[j].stn[m].frain[k].qual==0 ||            
                  pdata[j].stn[m].frain[k].qual==8 ||
                  pdata[j].stn[m].frain[k].qual==3 ||
		  pdata[j].stn[m].frain[k].qual==2))
                                ftotal=ftotal+pdata[j].stn[m].rain[k].data;
                                
              else {
              
                   ftotal=ftotal+fvalue[k];
                   
                 /*  if(pdata[j].stn[m].frain[k].qual != 1) {*/
                   
                       pdata[j].stn[m].frain[k].data=fvalue[k];
                       pdata[j].stn[m].frain[k].qual=5;
                       
                   /*    } */

              }
              
  
          }
                 
           
      pdata[j].stn[m].frain[k].data=ftotal;
      pdata[j].stn[m].frain[k].qual=4;
              
	
} 
 


/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source$";
 static char rcs_id2[] = "$Id$";}
/*  ===================================================  */

}

