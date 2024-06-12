## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
port <- httpuv::randomPort()
port

## ----eval = TRUE--------------------------------------------------------------
library(stream)
library(callr)

rp1 <- r_bg(function(port) {
  library(stream)
  stream <- DSD_Gaussians(k = 3, d = 3)
  blocksize <- 10

  con <- socketConnection(port = port, server = TRUE)
  
  while (TRUE) {
    write_stream(stream, con, n = blocksize, close = FALSE)
    Sys.sleep(1)
  }
  
  close(con)
}, 
  args = list(port = port))

rp1

## ----eval = TRUE--------------------------------------------------------------
con <- streamConnect::retry(socketConnection(port = port, open = 'r'))
con

dsd <- streamConnect::retry(DSD_ReadStream(con))

## ----eval = TRUE--------------------------------------------------------------
get_points(dsd, n= -1)
get_points(dsd, n= -1)

Sys.sleep(2)
get_points(dsd, n= -1)

close(con)

## ----eval = TRUE--------------------------------------------------------------
rp1$kill()

## ----eval = TRUE--------------------------------------------------------------
library(streamConnect)

rp1 <- DSD_Gaussians(k = 3, d = 3) %>% publish_DSD_via_Socket(port = port)
rp1

## ----eval = TRUE--------------------------------------------------------------
library(streamConnect)

dsd <- DSD_ReadSocket(port = port, col.names = c("x", "y", "z", ".class"))
dsd

get_points(dsd, n = 10)
plot(dsd)

close_stream(dsd)

## ----eval = TRUE--------------------------------------------------------------
if (rp1$is_alive()) rp1$kill()

## ----eval = TRUE--------------------------------------------------------------
library(streamConnect)

rp1 <- publish_DSC_via_WebService("DSC_DBSTREAM(r = .05)", port = port)
rp1

## ----echo=FALSE---------------------------------------------------------------
# sleep in case the WebService is not up fast enough. Maybe this make the CRAN checker happy. 
Sys.sleep(1)

## ----eval = TRUE--------------------------------------------------------------
library(streamConnect)

dsc <- DSC_WebService(paste0("http://localhost", ":", port), verbose = TRUE)
dsc

## ----eval = TRUE--------------------------------------------------------------
dsd <- DSD_Gaussians(k = 3, d = 2, noise = 0.05)

update(dsc, dsd, 500)
dsc


get_centers(dsc)
get_weights(dsc)

plot(dsc)

## ----eval = TRUE--------------------------------------------------------------
rp1$kill()

## ----eval = FALSE-------------------------------------------------------------
#  library(streamConnect)
#  port = 8001
#  
#  publish_DSC_via_WebService("DSC_DBSTREAM(r = .05)", port = port,
#                             background = FALSE)

## ----eval = FALSE-------------------------------------------------------------
#  publish_DSC_via_WebService("DSC_DBSTREAM(r = .05)", serve = FALSE)

