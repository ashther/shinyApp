checkAndLoadPackages <- function(){
  list.of.packages <- c("plyr", "httr", "rjson")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if (length(new.packages)) install.packages(new.packages)
  
  require(plyr)
  require(httr)
  require(rjson)
}

dataframeFromJSON <- function(l) {
  l1 <- lapply(l, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  keys <- unique(unlist(lapply(l1, names)))
  l2 <- lapply(l1, '[', keys)
  l3 <- lapply(l2, setNames, keys)
  res <- data.frame(do.call(rbind, l3))
  return(res)
}

getEmotionResponse <- function(img.path, key){
  
  emotionURL = "https://api.projectoxford.ai/emotion/v1.0/recognize"
  
  mybody = upload_file(img.path)
  
  emotionResponse = POST(
    url = emotionURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
  df <- dataframeFromJSON(content(emotionResponse))
  
  return(df)
}

getFaceResponse <- function(img.path, key){
  checkAndLoadPackages()
  faceURL = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,smile,facialHair,headPose"
  
  mybody = upload_file(img.path)
  
  faceResponse = POST(
    url = faceURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
  # con <- content(faceResponse)[[1]]
  #  df <- data.frame(t(unlist(con$faceAttributes)))
  
  better <- dataframeFromJSON(content(faceResponse))
  # cn <- c("faceAttributes.smile", "faceAttributes.gender", "faceAttributes.age", "faceAttributes.facialHair.moustache", "faceAttributes.facialHair.beard", "faceAttributes.facialHair.sideburns")
  df <-   better
  
  return(df) 
}