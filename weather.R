
#### libraries #########################################################################################################

library(httr)
library(parsedate)

#### connection ########################################################################################################

apiKey <- "cfa2b9cd5966b8defbe0a22e98e2db2f812d42e3"
api_key <- "..."

#### function ##########################################################################################################

getFromAPI<-function(model="coamps",grid="2a",coords=c(130,111),field="airtmp_pre_fcstfld",level="000010_000000",date="2018-01-01T00",apiKey){
  add_headers(
    Authorization=sprintf("Token %s",apiKey))->he
  url<-sprintf("https://api.meteo.pl/api/v1/model/%s/grid/%s/coordinates/%d,%d/field/%s/level/%s/date/%s/forecast/",
               model,grid,coords[1],coords[2],field,level,date);
  try(content(stop_for_status(POST(url,he))))->data
  if(inherits(data,"try-error")){
    return(NULL);
  }
  data$times<-parse_iso_8601(unlist(data$times))
  data$data<-unlist(data$data)
  as.data.frame(data)
}


getCoordsFromLatLon<-function(model="um",grid="C4",lat=52,lon=21,apiKey){
  add_headers(
    Authorization=sprintf("Token %s",apiKey))->he
  url<-sprintf("https://api.meteo.pl/api/v1/model/%s/grid/%s/nearbyPoints/%0.10f,%0.10f/",
               model,grid,lat,lon);
  unlist(content(stop_for_status(GET(url,he)))$points[[1]])
}


#### go! ###############################################################################################################

x <- getFromAPI(apiKey = apiKey)

x_coord <- getFromAPI(coords = getCoordsFromLatLon(apiKey = apiKey, lat = 57.25, lon = 22.6), apiKey = apiKey)
