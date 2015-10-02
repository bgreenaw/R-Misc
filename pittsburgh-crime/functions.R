change <- function(baseline, current){
  current[,2] <- baseline[,2] - current[,2]
  return(current)
}



inc_dec <- function(pct){
  require(scales) 
  if(pct < 0){
     return(alpha(muted("red")))
   }
   else if(pct > 0){
     return(alpha(muted("blue")))
   }
   else{
     return('grey75')
   }
}


inc_dec_fade <- function(pct){
  require(scales) 
  if(pct < 0){
    return(alpha(muted("red"), ifelse(abs(pct)/100<=1, abs(pct)/100, 1)))
  }
  else if(pct > 0){
    return(alpha(muted("blue"), ifelse(abs(pct)/100<=1, abs(pct)/100, 1)))
  }
  else{
    return('grey85')
  }
}
